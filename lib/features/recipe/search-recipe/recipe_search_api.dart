import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeSearchAPI {
  static const String appId = '944184b7';
  static const String appKey = '32a51da0f5bf093de7b4cd19e2f55112';
  static const String baseUrl = 'https://api.edamam.com';

  // with ingredients
  // https://api.edamam.com/api/recipes/v2?type=public&app_id=your_app_id&app_key=your_app_key&q=chicken,garlic,onion&random=true

  // Future<List<Recipe>> fetchRecipes(List<String> ingredients) async {
  //   String ingredientQuery = ingredients.join(',');
  //   var url = Uri.parse(
  //       'https://api.edamam.com/api/recipes/v2?type=public&app_id=your_app_id&app_key=your_app_key&q=$ingredientQuery&random=true');
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     List<Recipe> recipes = data['hits']
  //         .map<Recipe>((data) => Recipe.fromJson(data['recipe']))
  //         .toList();
  //     return recipes;
  //   } else {
  //     throw Exception('Failed to load recipes');
  //   }
  // }

  // Construct the URL for the Edamam Recipe Search API
  static Future<Map<String, dynamic>> searchRecipes(
      String searchKey, String queryParams,
      {String? nextUrl}) async {
    final String url = nextUrl ??
        '$baseUrl/api/recipes/v2?q=$searchKey&app_id=$appId&app_key=$appKey&type=public$queryParams';

    print(url);
    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        print('Error: ${response.statusCode}');
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipes');
    }
  }

  // Construct the URL for the Edamam Recipe Search API
  static Future<Map<String, dynamic>> searchRecipeById(String recipeId) async {
    final String url =
        '$baseUrl/api/recipes/v2/$recipeId?app_id=$appId&app_key=$appKey&type=public';

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON data
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          return data;
        } else {
          throw Exception('Recipe not found.');
        }
      } else {
        throw Exception('Failed to load recipe: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load recipes');
    }
  }
}
