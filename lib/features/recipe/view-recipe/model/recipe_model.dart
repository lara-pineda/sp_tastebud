class Recipe {
  final String uri;
  final String label;
  final String image;
  final Map<String, ImageDetails> images;
  final String source;
  final String url;
  final String shareAs;
  final int yield;
  final List<String> dietLabels;
  final List<String> healthLabels;
  final List<String> cautions;
  final List<String> ingredientLines;
  final List<Ingredient> ingredients;
  final int calories;
  final int totalCO2Emissions;
  final String co2EmissionsClass;
  final int totalWeight;
  final int totalTime;
  final List<String> cuisineType;
  final List<String> mealType;
  // final List<String> dishType;
  // final List<String> instructions;
  final List<String> tags;
  // final String externalId;
  final NutrientInfo totalNutrients;
  final NutrientInfo totalDaily;
  final List<Digest> digest;

  Recipe({
    required this.uri,
    required this.label,
    required this.image,
    required this.images,
    required this.source,
    required this.url,
    required this.shareAs,
    required this.yield,
    required this.dietLabels,
    required this.healthLabels,
    required this.cautions,
    required this.ingredientLines,
    required this.ingredients,
    required this.calories,
    required this.totalCO2Emissions,
    required this.co2EmissionsClass,
    required this.totalWeight,
    required this.totalTime,
    required this.cuisineType,
    required this.mealType,
    // required this.dishType,
    // required this.instructions,
    required this.tags,
    // required this.externalId,
    required this.totalNutrients,
    required this.totalDaily,
    required this.digest,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        uri: json['uri'] ?? '',
        label: json['label'] ?? '',
        image: json['image'] ?? '',
        images: (json['images'] as Map<String, dynamic>?)?.map((k, v) =>
                MapEntry(
                    k, ImageDetails.fromJson(v as Map<String, dynamic>))) ??
            {},
        source: json['source'] ?? '',
        url: json['url'] ?? '',
        shareAs: json['shareAs'] ?? '',
        yield: (json['yield'] as num?)?.toInt() ?? 0,
        dietLabels: List<String>.from(json['dietLabels'] ?? []),
        healthLabels: List<String>.from(json['healthLabels'] ?? []),
        cautions: List<String>.from(json['cautions'] ?? []),
        ingredientLines: List<String>.from(json['ingredientLines'] ?? []),
        ingredients: (json['ingredients'] as List<dynamic> ?? [])
            .map((i) => Ingredient.fromJson(i))
            .toList(),
        calories: (json['calories'] as num?)?.toInt() ?? 0,
        totalCO2Emissions: (json['totalCO2Emissions'] as num?)?.toInt() ?? 0,
        co2EmissionsClass: json['co2EmissionsClass'] ?? '',
        totalWeight: (json['totalWeight'] as num?)?.toInt() ?? 0,
        totalTime: (json['totalTime'] as num?)?.toInt() ?? 0,
        cuisineType: List<String>.from(json['cuisineType'] ?? []),
        mealType: List<String>.from(json['mealType'] ?? []),
        // dishType: List<String>.from(json['dishType']),
        // instructions: List<String>.from(json['instructions']),
        tags: List<String>.from(json['tags'] ?? []),
        // externalId: json['externalId'],
        totalNutrients: NutrientInfo.fromJson(json['totalNutrients'] ?? {}),
        totalDaily: NutrientInfo.fromJson(json['totalDaily'] ?? {}),
        digest: (json['digest'] as List<dynamic> ?? [])
            .map((d) => Digest.fromJson(d))
            .toList(),
      );
}

class ImageDetails {
  final String url;
  final int width;
  final int height;

  ImageDetails({required this.url, required this.width, required this.height});

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      url: json['url'] ?? '',
      width: (json['width'] as num?)?.toInt() ?? 0,
      height: (json['height'] as num?)?.toInt() ?? 0,
    );
  }
}

class Ingredient {
  final String text;
  final int quantity;
  final String measure;
  final String food;
  final int weight;
  final String foodId;

  Ingredient({
    required this.text,
    required this.quantity,
    required this.measure,
    required this.food,
    required this.weight,
    required this.foodId,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      text: json['text'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      measure: json['measure'] ?? '',
      food: json['food'] ?? '',
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      foodId: json['foodId'] ?? '',
    );
  }
}

class NutrientInfo {
  final Map<String, Nutrient> nutrients;

  NutrientInfo({required this.nutrients});

  factory NutrientInfo.fromJson(Map<String, dynamic> json) {
    return NutrientInfo(
      nutrients:
          Map.from(json).map((k, v) => MapEntry(k, Nutrient.fromJson(v))),
    );
  }
}

class Nutrient {
  final String label;
  final double quantity;
  final String unit;

  Nutrient({required this.label, required this.quantity, required this.unit});

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      label: json['label'] ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
    );
  }
}

class Digest {
  final String label;
  final String tag;
  final String? schemaOrgTag;
  final int total;
  final bool hasRDI;
  final int daily;
  final String unit;
  final List<Sub> sub;

  Digest({
    required this.label,
    required this.tag,
    this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.daily,
    required this.unit,
    required this.sub,
  });

  factory Digest.fromJson(Map<String, dynamic> json) {
    return Digest(
      label: json['label'] ?? '',
      tag: json['tag'] ?? '',
      schemaOrgTag: json['schemaOrgTag'],
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasRDI: json['hasRDI'] ?? false,
      daily: (json['daily'] as num?)?.toInt() ?? 0,
      unit: json['unit'] ?? '',
      sub: (json['sub'] as List<dynamic>?)
              ?.map((s) => Sub.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class Sub {
  final String label;
  final String tag;
  final String? schemaOrgTag;
  final int total;
  final bool hasRDI;
  final int daily;
  final String unit;
  final Map<String, dynamic>? sub;

  Sub({
    required this.label,
    required this.tag,
    this.schemaOrgTag,
    required this.total,
    required this.hasRDI,
    required this.daily,
    required this.unit,
    this.sub,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    return Sub(
      label: json['label'] ?? '',
      tag: json['tag'] ?? '',
      schemaOrgTag: json['schemaOrgTag'],
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasRDI: json['hasRDI'] ?? false,
      daily: (json['daily'] as num?)?.toInt() ?? 0,
      unit: json['unit'] ?? '',
      sub: json['sub'] as Map<String, dynamic>?,
    );
  }
}
