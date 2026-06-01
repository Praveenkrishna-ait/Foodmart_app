import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF10B981); // Emerald Green
  static const Color primaryOrange = Color(0xFFF97316); // Vibrant Amber/Orange
  static const Color backgroundLight = Color(0xFFF8FAFC); // Smooth slate white
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF0F172A); // Deep slate
  static const Color textMuted = Color(0xFF64748B); // Slate grey

  // Gradients
  static const Gradient primaryOrangeGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFF8A00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient freshGreenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient glassGradient = LinearGradient(
    colors: [Colors.white24, Colors.white12],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient premiumBgGradient = LinearGradient(
    colors: [Color(0xFFFEF3C7), Color(0xFFFFEDD5)], // Soft premium golden sunset
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Modern Box Shadows
  static List<BoxShadow> premiumShadow = [
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.04),
      offset: const Offset(0, 8),
      blurRadius: 24,
    ),
    BoxShadow(
      color: const Color(0xFF0F172A).withOpacity(0.02),
      offset: const Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      offset: const Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: primaryOrange,
        background: backgroundLight,
        surface: cardLight,
      ),
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textDark,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textMuted,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
