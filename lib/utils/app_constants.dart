import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const List<String> baseCategories = [
    'Planet',
    'Star',
    'Galaxy',
    'Comet',
    'Black Hole',
    'Moon',
    'Satellite',
  ];

  static const String createCustomCategoryOption = 'Create custom...';

  static const Map<String, IconData> categoryIcons = {
    'Planet': Icons.public,
    'Star': Icons.star,
    'Galaxy': Icons.blur_circular,
    'Comet': Icons.flash_on,
    'Black Hole': Icons.brightness_1,
    'Moon': Icons.nightlight_round,
    'Satellite': Icons.satellite_alt,
  };

  static IconData getCategoryIcon(String category) {
    return categoryIcons[category] ?? Icons.auto_awesome;
  }
}
