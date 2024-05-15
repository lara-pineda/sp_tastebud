class Recipe {
  final String? label;
  final String? image;
  final String? url;
  final String? source;
  final double? yield;
  final double? calories;
  final List<String> cuisineType;
  final List<String> mealType;
  final List<String> tags;
  final List<String> ingredientLines;
  final Nutrients totalNutrients;
  final Nutrients totalDaily;
  final List<Digest> digest;

  Recipe({
    this.label,
    this.image,
    this.url,
    this.source,
    this.yield,
    this.calories,
    required this.cuisineType,
    required this.mealType,
    required this.tags,
    required this.ingredientLines,
    required this.totalNutrients,
    required this.totalDaily,
    required this.digest,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      label: json['label'] ?? 'No Label',
      image: json['image'] ?? '',
      url: json['url'] ?? '',
      source: json['source'] ?? 'Unknown',
      yield: (json['yield'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      cuisineType: List<String>.from(json['cuisineType'] ?? []),
      mealType: List<String>.from(json['mealType'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      ingredientLines: List<String>.from(json['ingredientLines'] ?? []),
      totalNutrients: Nutrients.fromJson(json['totalNutrients'] ?? {}),
      totalDaily: Nutrients.fromJson(json['totalDaily'] ?? {}),
      digest: (json['digest'] as List<dynamic>?)
              ?.map((e) => Digest.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
