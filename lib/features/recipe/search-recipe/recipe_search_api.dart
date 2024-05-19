import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeSearchAPI {
  static const String appId = '944184b7';
  static const String appKey = '32a51da0f5bf093de7b4cd19e2f55112';
  static const String baseUrl = 'https://api.edamam.com';

  static final Map<String, CacheEntry> _cache = {};
  static const int cacheDuration = 3600;

  static Future<Map<String, dynamic>> searchRecipes(
      {required String searchKey,
      required String queryParams,
      required List<String> ingredients,
      String? nextUrl,
      bool forceUpdate = false // for clearing cache
      }) async {
    String query;

    if (forceUpdate) {
      print('force update !!');
      print(searchKey);
      print(ingredients);
      print(queryParams);
      print('end of force update.');
    }
    if (ingredients.isNotEmpty) {
      // Join the ingredients list into a single string with replacements
      String formattedIngredients = ingredients
          .map((ingredient) => ingredient
              .toLowerCase()
              .replaceAll(' ', '%20')) // Replace spaces with '%20'
          .join('%2C'); // Join elements with '%2C'

      // Joining search key with ingredients
      query = '$searchKey%2C$formattedIngredients';
    } else {
      query = '$searchKey';
    }

    print('query: $query');

    final String url = nextUrl ??
        '$baseUrl/api/recipes/v2?q=$query&app_id=$appId&app_key=$appKey&type=public$queryParams';

    // Clear the cache if forceUpdate is true
    if (forceUpdate) {
      _cache.clear();
    }

    if (_cache.containsKey(url)) {
      CacheEntry entry = _cache[url]!;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - entry.timestamp < cacheDuration * 1000) {
        print('Loading from cache: $url');
        return entry.data;
      } else {
        _cache.remove(url);
      }
    }

    print('received ingredients: $ingredients');
    print('Fetching from API: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _cache[url] = CacheEntry(data, DateTime.now().millisecondsSinceEpoch);
        return data;
      } else if (response.statusCode == 403) {
        throw Exception('Access Denied: Invalid API Key or App ID');
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Failed to load recipes');
    }
  }

  static Future<Map<String, dynamic>> searchRecipeById(String recipeId) async {
    final String url =
        '$baseUrl/api/recipes/v2/$recipeId?app_id=$appId&app_key=$appKey&type=public';

    if (_cache.containsKey(url)) {
      CacheEntry entry = _cache[url]!;
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      if (currentTime - entry.timestamp < cacheDuration * 1000) {
        print('Loading from cache: $url');
        return entry.data;
      } else {
        _cache.remove(url);
      }
    }

    print('Fetching from API: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        _cache[url] = CacheEntry(data, DateTime.now().millisecondsSinceEpoch);
        return data;
      } else if (response.statusCode == 403) {
        throw Exception('Access Denied: Invalid API Key or App ID');
      } else {
        throw Exception('Failed to load recipe: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load recipes');
    }
  }
}

class CacheEntry {
  final Map<String, dynamic> data;
  final int timestamp;

  CacheEntry(this.data, this.timestamp);
}
