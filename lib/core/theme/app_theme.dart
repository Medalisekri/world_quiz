import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Dark Neon Colors
  static const Color neonBlue = Color(0xFF00E5FF);
  static const Color neonGreen = Color(0xFF00FF9D);
  static const Color neonRed = Color(0xFFFF3366);
  static const Color neonWhite =  Color(0xFFFAFFFF);
  static const Color darkBackground = Color(0xFF0A0E14);
  static const Color darkSurface = Color(0xFF151A23);

  // Light Theme Colors
  static const Color lightBackground = Color(0xFFF4F6F8);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF0077B6);
  static const Color lightSecondary = Color(0xFF00B4D8);
  static const Color lightError = Color(0xFFEF233C);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: neonBlue,
        onPrimary: Colors.black,
        secondary: neonGreen,
        onSecondary: Colors.black,
        error: neonRed,
        onError: Colors.white,
        surface: darkSurface,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonBlue,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: lightPrimary,
        onPrimary: Colors.white,
        secondary: lightSecondary,
        onSecondary: Colors.white,
        error: lightError,
        onError: Colors.white,
        surface: lightSurface,
        onSurface: Color(0xFF1D3557),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme , ) ,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Color(0xFF1D3557), fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        iconTheme: IconThemeData(color: Color(0xFF1D3557)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}