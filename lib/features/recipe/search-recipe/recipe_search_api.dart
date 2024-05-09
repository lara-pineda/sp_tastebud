import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RecipeSearchAPI {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  RecipeSearchAPI(this._firestore, this._firebaseAuth);

  // Construct the URL for the Edamam Recipe Search API
  static Future<List<dynamic>> searchRecipes(String query) async {
    // 3scale credentials
    const String appId = '944184b7';
    const String appKey = '32a51da0f5bf093de7b4cd19e2f55112';
    const String baseUrl = 'https://api.edamam.com';

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

  // Construct the URL for the Edamam Recipe Search API
  static Future<Map<String, dynamic>> searchRecipeById(String recipeId) async {
    // 3scale credentials
    const String appId = '944184b7';
    const String appKey = '32a51da0f5bf093de7b4cd19e2f55112';
    const String baseUrl = 'https://api.edamam.com';

    final String url =
        '$baseUrl/api/recipes/v2/$recipeId?type=public&app_id=$appId&app_key=$appKey';

    try {
      // Make the HTTP request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON data
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          return data['recipe'];
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
