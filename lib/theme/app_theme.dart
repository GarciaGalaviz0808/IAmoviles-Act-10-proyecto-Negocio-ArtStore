import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Nueva Paleta Artística en Cafés
  static const Color backgroundCanvas = Color(0xFFF2E6DA); // Fondo solicitado
  static const Color primaryCoffee = Color(0xFF5D4037);    // Café chocolate
  static const Color deepCoffee = Color(0xFF3E2723);       // Café oscuro para títulos
  static const Color accentSienna = Color(0xFF8D6E63);     // Café claro
  static const Color artisticOrange = Color(0xFFD35400);   // Naranja tierra/óxido

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryCoffee,
        primary: primaryCoffee,
        secondary: artisticOrange,
        surface: backgroundCanvas,
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: deepCoffee,
        ),
        titleLarge: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: deepCoffee,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCoffee,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bordes más clásicos
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          elevation: 5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: accentSienna),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: accentSienna.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryCoffee, width: 2),
        ),
      ),
    );
  }
}
