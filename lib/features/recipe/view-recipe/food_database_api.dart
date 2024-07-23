import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodDatabaseAPI {
  final appId = dotenv.env['FOOD_DB_APPID'];
  final appKey = dotenv.env['FOOD_DB_APPKEY'];

  static const String baseUrl = 'https://api.edamam.com';
  static const String measureUri =
      "http://www.edamam.com/ontologies/edamam.owl#Measure_serving";
  static const int quantity = 0;

  static Future<Map<String, dynamic>> getNutritionalInfo(String foodId) async {
    const String endpoint = '/api/food-database/v2/nutrients';
    final url = Uri.parse('$baseUrl$endpoint?app_id=$appId&app_key=$appKey');

    // Build the request body
    final requestBody = {
      'ingredients': [
        {'quantity': quantity, 'measureURI': measureUri, 'foodId': foodId}
      ]
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load nutritional information');
    }
  }
}
