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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      uri: json['uri'],
      label: json['label'],
      image: json['image'],
      images: Map.from(json['images'])
          .map((k, v) => MapEntry(k, ImageDetails.fromJson(v))),
      source: json['source'],
      url: json['url'],
      shareAs: json['shareAs'],
      yield: json['yield'].toInt(),
      dietLabels: List<String>.from(json['dietLabels']),
      healthLabels: List<String>.from(json['healthLabels']),
      cautions: List<String>.from(json['cautions']),
      ingredientLines: List<String>.from(json['ingredientLines']),
      ingredients: List.from(json['ingredients'])
          .map((i) => Ingredient.fromJson(i))
          .toList(),
      calories: (json['calories'] is int)
          ? json['calories']
          : json['calories'].toInt(),
      totalCO2Emissions: (json['totalCO2Emissions'] is int)
          ? json['totalCO2Emissions']
          : json['totalCO2Emissions'].toInt(),
      co2EmissionsClass: json['co2EmissionsClass'],
      totalWeight: (json['totalWeight'] is int)
          ? json['totalWeight']
          : json['totalWeight'].toInt(),
      totalTime: (json['totalTime'] is int)
          ? json['totalTime']
          : json['totalTime'].toInt(),
      cuisineType: List<String>.from(json['cuisineType']),
      mealType: List<String>.from(json['mealType']),
      // dishType: List<String>.from(json['dishType']),
      // instructions: List<String>.from(json['instructions']),
      tags: List<String>.from(json['tags']),
      // externalId: json['externalId'],
      totalNutrients: NutrientInfo.fromJson(json['totalNutrients']),
      totalDaily: NutrientInfo.fromJson(json['totalDaily']),
      digest: List.from(json['digest']).map((d) => Digest.fromJson(d)).toList(),
    );
  }
}

class ImageDetails {
  final String url;
  final int width;
  final int height;

  ImageDetails({required this.url, required this.width, required this.height});

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      url: json['url'],
      width: json['width'],
      height: json['height'],
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
      text: json['text'],
      quantity: (json['quantity'] is int)
          ? json['quantity']
          : json['quantity'].toInt(),
      measure: json['measure'],
      food: json['food'],
      weight: (json['weight'] is int) ? json['weight'] : json['weight'].toInt(),
      foodId: json['foodId'],
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
  final int quantity;
  final String unit;

  Nutrient({
    required this.label,
    required this.quantity,
    required this.unit,
  });

  factory Nutrient.fromJson(Map<String, dynamic> json) {
    return Nutrient(
      label: json['label'],
      quantity: (json['quantity'] is int)
          ? json['quantity']
          : json['quantity'].toInt(),
      unit: json['unit'],
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
      label: json['label'],
      tag: json['tag'],
      schemaOrgTag: json['schemaOrgTag'],
      total: (json['total'] is int) ? json['total'] : json['total'].toInt(),
      hasRDI: json['hasRDI'],
      daily: (json['daily'] is int) ? json['daily'] : json['daily'].toInt(),
      unit: json['unit'],
      sub: json['sub'] != null
          ? List<Sub>.from(json['sub'].map((s) => Sub.fromJson(s)))
          : [],
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
      label: json['label'],
      tag: json['tag'],
      schemaOrgTag: json['schemaOrgTag'],
      total: (json['total'] is int) ? json['total'] : json['total'].toInt(),
      hasRDI: json['hasRDI'],
      daily: (json['daily'] is int) ? json['daily'] : json['daily'].toInt(),
      unit: json['unit'],
      sub: json['sub'] as Map<String, dynamic>?,
    );
  }
}
