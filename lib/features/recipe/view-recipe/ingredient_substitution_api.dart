import 'dart:convert'; // Import JSON decoder
import 'package:http/http.dart' as http;
import 'package:openapi/api.dart';
import 'model/ingredient_substitute_response_model.dart';

class IngredientSubstitutionAPI {
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
            IngredientSubstituteResponse.fromJson(jsonResponse);

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

  // void setupSpoonacularAPI(String ingredientName) async {
  //   final apiInstance = DefaultApi();
  //   final analyzeRecipeRequest =
  //       AnalyzeRecipeRequest(); // example request body.
  //   const language = 'en';
  //   const includeNutrition = false;
  //   const includeTaste = false;
  //
  //   try {
  //     // TODO Configure API key authorization: apiKeyScheme
  //     defaultApiClient.authentication?.apiKey =
  //         '1c91b8b1f14e4993abc834a80a93c564';
  //     // uncomment below to setup prefix (e.g. Bearer) for API key, if needed
  //     defaultApiClient
  //         .getAuthentication<ApiKeyAuth>('apiKeyScheme')
  //         .apiKeyPrefix = 'Bearer';
  //
  //     try {
  //       final result = apiInstance.analyzeRecipe(analyzeRecipeRequest,
  //           language: language,
  //           includeNutrition: includeNutrition,
  //           includeTaste: includeTaste);
  //       print(result);
  //     } catch (e) {
  //       print('Exception when calling DefaultApi->analyzeRecipe: $e\n');
  //     }
  //   } catch (e) {
  //     print("Exception when calling RecipeApi: $e\n");
  //   }
  // }
  //
  // void getIngredientSubstituteSpoonacular(String ingredientName) {
  //   // TODO Configure API key authorization: apiKeyScheme
  //   defaultApiClient.getAuthentication<ApiKeyAuth>('apiKeyScheme').apiKey =
  //       '1c91b8b1f14e4993abc834a80a93c564';
  //   // uncomment below to setup prefix (e.g. Bearer) for API key, if needed
  //   //defaultApiClient.getAuthentication<ApiKeyAuth>('apiKeyScheme').apiKeyPrefix = 'Bearer';
  //
  //   final encodedIngredientName = ingredientName.replaceAll(' ', '%20');
  //   print(encodedIngredientName);
  //   // var url = Uri.parse('$baseUrl?ingredientName=$encodedIngredientName');
  //
  //   final api_instance = IngredientsApi();
  //
  //   try {
  //     final result = api_instance.getIngredientSubstitutes(ingredientName);
  //     print(result);
  //   } catch (e) {
  //     print(
  //         'Exception when calling IngredientsApi->getIngredientSubstitutes: $e\n');
  //   }
  // }
}
