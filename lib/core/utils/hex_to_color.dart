import 'package:flutter/material.dart';

extension ColorExtension on String {
  /// this function converts hex codes to proper Color format in Flutter
  toColor() {
    var hexString = this;
    return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
