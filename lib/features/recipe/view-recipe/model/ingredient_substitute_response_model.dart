class IngredientSubstituteResponseRapidAPI {
  final String status;
  final String ingredient;
  final List<String> substitutes;
  final String message;

  IngredientSubstituteResponseRapidAPI({
    required this.status,
    required this.ingredient,
    required this.substitutes,
    required this.message,
  });

  factory IngredientSubstituteResponseRapidAPI.fromJson(
      Map<String, dynamic> json) {
    return IngredientSubstituteResponseRapidAPI(
      status: json['status'],
      ingredient: json['ingredient'],
      substitutes: List<String>.from(json['substitutes']),
      message: json['message'],
    );
  }
}

class IngredientSubstituteResponseSpoonacular {
  final String ingredient;
  final List<String> substitutes;
  final String message;

  IngredientSubstituteResponseSpoonacular({
    required this.ingredient,
    required this.substitutes,
    required this.message,
  });

  factory IngredientSubstituteResponseSpoonacular.fromJson(
      Map<String, dynamic> json) {
    return IngredientSubstituteResponseSpoonacular(
      ingredient: json['ingredient'],
      substitutes: List<String>.from(json['substitutes']),
      message: json['message'],
    );
  }
}
