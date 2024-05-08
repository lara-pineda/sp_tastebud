import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeSearchAPI {
  // Construct the URL for the Edamam Recipe Search API
  static Future<List<dynamic>> searchRecipes(String query) async {
    // 3scale credentials
    final String appId = '944184b7';
    final String appKey = '32a51da0f5bf093de7b4cd19e2f55112';
    final String baseUrl = 'https://api.edamam.com';

    final String url =
        '$baseUrl/api/recipes/v2?q=$query&app_id=$appId&app_key=$appKey&type=public';

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['hits'].map((hit) => hit['recipe']).toList();
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipes');
    }
  }
}
