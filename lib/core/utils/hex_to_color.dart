import 'package:flutter/material.dart';

/// This function converts hex codes to proper Color format in Flutter
extension ColorExtension on String {
  toColor() {
    var hexString = this;
    return Color(int.parse(hexString.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
