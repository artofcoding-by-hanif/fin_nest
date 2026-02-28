import 'package:flutter/material.dart';

/// Application theme configuration
class AppTheme {
  // TODO: Define light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // TODO: Add theme customizations
    );
  }
  
  // TODO: Define dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // TODO: Add theme customizations
    );
  }
}

