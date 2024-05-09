import 'nutrient_model.dart';

class Recipe {
  final String uri;
  final String label;
  // final Map<String, ImageDetails> images;
  final String imageUrl;
  final String source;
  final int yield;
  final List<String> ingredientLines;
  final double calories;
  final List<Nutrient> nutrients;

  Recipe({
    required this.uri,
    required this.label,
    // required this.images,
    required this.imageUrl,
    required this.source,
    required this.yield,
    required this.ingredientLines,
    required this.calories,
    required this.nutrients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Map<String, ImageDetails> images = {};
    // if (json['images'] != null) {
    //   json['images'].forEach((key, value) {
    //     images[key] = ImageDetails.fromJson(value);
    //   });
    // }

    // var nutrientsList = (json['totalNutrients'] as Map<String, dynamic>)
    //     .map((key, e) => MapEntry(key, Nutrient.fromJson(e)))
    //     .values
    //     .toList();

    var nutrientsList = (json['totalNutrients'] as Map<String, dynamic>)
        .values
        .map((e) => Nutrient.fromJson(e))
        .toList();

    print(nutrientsList);

    return Recipe(
      uri: json['uri'],
      label: json['label'],
      imageUrl: json['images']['THUMBNAIL']['url'],
      source: json['source'],
      yield: json['yield'],
      ingredientLines: List<String>.from(json['ingredientLines']),
      calories: json['calories'],
      nutrients: nutrientsList,
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
      url: json['url'] ?? '',
      width: json['width']?.toInt() ?? 0,
      height: json['height']?.toInt() ?? 0,
    );
  }
}
