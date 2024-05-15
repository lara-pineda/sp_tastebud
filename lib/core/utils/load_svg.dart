import 'package:flutter/services.dart' show rootBundle;

Future<String> loadSvgFromAssets(String assetPath) async {
  final svgString = await rootBundle.loadString(assetPath);
  return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>SVG Display</title>
    </head>
    <body style="margin: 0; padding: 0; display: flex; align-items: center; justify-content: center; height: 100vh;">
      $svgString
    </body>
    </html>
  ''';
}
