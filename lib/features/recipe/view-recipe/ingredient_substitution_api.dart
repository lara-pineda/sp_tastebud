import 'dart:convert'; // Import JSON decoder
import 'package:http/http.dart' as http;
import 'model/ingredient_substitute_response_model.dart';

class IngredientSubstitutionAPI {
  static const String apiKey = '1c91b8b1f14e4993abc834a80a93c564';
  static const String baseUrl =
      'https://api.spoonacular.com/food/ingredients/substitutes';

  static Future<IngredientSubstituteResponseSpoonacular?>
      getIngredientSubstitute({String query = ''}) async {
    final url = '$baseUrl?ingredientName=$query&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        // Check if substitutes are found
        if (jsonResponse.containsKey('substitutes')) {
          // Substitutes found, parse the response
          return IngredientSubstituteResponseSpoonacular.fromJson(jsonResponse);
        } else {
          // No substitutes found, construct response manually
          return IngredientSubstituteResponseSpoonacular(
            ingredient: query,
            substitutes: [],
            message: jsonResponse['message'],
          );
        }
      } else {
        print('Failed to load ingredient substitutes');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void getIngredientSubstitutesRapidAPI(String ingredientName) async {
    // pre-defined headers
    final Map<String, String> headers = {
      "X-RapidAPI-Key": "6952326c6amsh579671cd91ffa58p1d0b93jsn135c5cfdbb40",
      "X-RapidAPI-Host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    };

    const String baseUrl =
        "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/food/ingredients/substitutes";

    // final encodedIngredientName = ingredientName.replaceAll(' ', '%20');
    final encodedIngredientName = Uri.encodeComponent(ingredientName);
    print(encodedIngredientName);

    var url = Uri.parse('$baseUrl?ingredientName=$encodedIngredientName');

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var ingredientSubstitutes =
            IngredientSubstituteResponseRapidAPI.fromJson(jsonResponse);

        // use `ingredientSubstitutes` to access the properties
        print('Status: ${ingredientSubstitutes.status}');
        print('Ingredient: ${ingredientSubstitutes.ingredient}');
        print('Substitutes: ${ingredientSubstitutes.substitutes.join(", ")}');
        print('Message: ${ingredientSubstitutes.message}');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
