import 'package:ayurved_care/utils/app_color.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    fontFamily: 'Poppins',

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.lightTextSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: AppColors.lightTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColorLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColorLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.lightTextSecondary),
      // Add label text color
      labelStyle: const TextStyle(color: AppColors.primaryGreen),
      floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen),
    ),

    // Add text selection theme for cursor and selection colors
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryGreen,
      selectionColor: AppColors.primaryGreen,
      selectionHandleColor: AppColors.primaryGreen,
    ),

    // Add date picker theme
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: AppColors.primaryGreen,
      headerForegroundColor: Colors.white,
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return Colors.transparent;
      }),
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return Colors.transparent;
      }),
      weekdayStyle: TextStyle(
        color: Colors.grey[600],
        fontWeight: FontWeight.w500,
      ),
      yearStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      dayStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),

    // Add time picker theme
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: AppColors.primaryGreen.withOpacity(0.1),
      hourMinuteTextColor: AppColors.primaryGreen,
      dayPeriodColor: AppColors.primaryGreen.withOpacity(0.1),
      dayPeriodTextColor: AppColors.primaryGreen,
      dialHandColor: AppColors.primaryGreen,
      dialBackgroundColor: AppColors.primaryGreen.withOpacity(0.1),
      entryModeIconColor: AppColors.primaryGreen,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightAccent,
      foregroundColor: Colors.white,
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    fontFamily: 'Poppins',

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkTextPrimary, fontSize: 16),
      bodyMedium: TextStyle(color: AppColors.darkTextSecondary, fontSize: 14),
      titleLarge: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColorDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColorDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
      // Add label text color
      labelStyle: const TextStyle(color: AppColors.primaryGreen),
      floatingLabelStyle: const TextStyle(color: AppColors.primaryGreen),
    ),

    // Add text selection theme for cursor and selection colors
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryGreen,
      selectionColor: AppColors.primaryGreen,
      selectionHandleColor: AppColors.primaryGreen,
    ),

    // Add date picker theme for dark mode
    datePickerTheme: DatePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      headerBackgroundColor: AppColors.primaryGreen,
      headerForegroundColor: Colors.white,
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return Colors.transparent;
      }),
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryGreen;
        }
        return Colors.transparent;
      }),
      weekdayStyle: TextStyle(
        color: Colors.grey[400],
        fontWeight: FontWeight.w500,
      ),
      yearStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      dayStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),

    // Add time picker theme for dark mode
    timePickerTheme: TimePickerThemeData(
      backgroundColor: AppColors.darkSurface,
      hourMinuteColor: AppColors.primaryGreen.withOpacity(0.2),
      hourMinuteTextColor: AppColors.primaryGreen,
      dayPeriodColor: AppColors.primaryGreen.withOpacity(0.2),
      dayPeriodTextColor: AppColors.primaryGreen,
      dialHandColor: AppColors.primaryGreen,
      dialBackgroundColor: AppColors.primaryGreen.withOpacity(0.2),
      entryModeIconColor: AppColors.primaryGreen,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightAccent,
      foregroundColor: Colors.white,
    ),
  );
}
