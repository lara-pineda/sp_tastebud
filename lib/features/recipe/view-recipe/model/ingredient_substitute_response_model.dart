class IngredientSubstituteResponse {
  final String status;
  final String ingredient;
  final List<String> substitutes;
  final String message;

  IngredientSubstituteResponse({
    required this.status,
    required this.ingredient,
    required this.substitutes,
    required this.message,
  });

  factory IngredientSubstituteResponse.fromJson(Map<String, dynamic> json) {
    return IngredientSubstituteResponse(
      status: json['status'],
      ingredient: json['ingredient'],
      substitutes: List<String>.from(json['substitutes']),
      message: json['message'],
    );
  }
}
