import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFFED809D);
  static const Color primaryLight = Color(0xFFED809D);
  static const Color textLight = Color(0xFF2A2A2A); // Dark Gray

  static const Color subtextLight = Colors.black; // Neutral Gray

  static const Color backgroundLight = Color(0xFFED809D); // Pale Pink Rose

  static const Color cardLight = Color(0xFFF3A8BC); // Soft pink-white
  static const Color buttonDark = Color(0xFFED809D); // Citrin

  static List<Color> getBackgroundGradient(bool isDarkMode) {
    return [
      Color(0xFFFFE0EB), // Pale Pink
      Color(0xFFFFF5F7), // Very Light Pink
    ];
  }
}
