import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF006837); // Deep green (buttons/logo)
  static const Color secondaryGreen = Color(0xFF009688); // Accent teal green

  // Light Mode Colors
  static const Color lightPrimary = primaryGreen;
  static const Color lightAccent = secondaryGreen;
  static const Color lightBackground = Colors.white;
  static const Color lightSurface = Color(0xFFF5F5F5); // Light gray for cards
  static const Color lightTextPrimary = Color(0xFF212121); // Almost black
  static const Color lightTextSecondary = Color(0xFF757575); // Medium gray
  static const Color lightError = Color(0xFFD32F2F); // Red error

  // Dark Mode Colors
  static const Color darkPrimary = primaryGreen; // Keep same green brand color
  static const Color darkAccent = secondaryGreen;
  static const Color darkBackground = Color(0xFF121212); // Dark background
  static const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter dark for cards
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Colors.white70;
  static const Color darkError = Color(0xFFEF9A9A); // Softer red for dark mode

  // Extra Utilities
  static const Color successColor = Colors.green;
  static const Color warningColor = Colors.orange;
  static const Color borderColorLight = Color(0xFFE0E0E0);
  static const Color borderColorDark = Colors.white30;
}
