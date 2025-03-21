import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimalist_todo/config/globals_app.dart' as globals;

abstract class ThemeApp {
  static ThemeData get themeData {
    return ThemeData(
      scaffoldBackgroundColor: globals.primaryLightColor,
      appBarTheme: AppBarTheme(
        backgroundColor: globals.primaryLightColor,
        iconTheme: IconThemeData(color: globals.neutralColor),
        centerTitle: true,
      ),

      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primaryContainer: globals.primaryLightColor,
        primary: globals.primaryLightColor,
        onPrimary: globals.secondaryLightColor,
        secondary: globals.secondaryLightColor,
        onSecondary: globals.secondaryLightColor,
        error: globals.red,
        onError: globals.red.withAlpha(100),
        surface: globals.secondaryLightColor,
        onSurface: globals.secondaryLightColor,
        tertiary: globals.terciaryLightColor,
        inversePrimary: globals.primaryDarkColor,
        inverseSurface: globals.secondaryDarkColor,
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.ubuntu(
          fontSize: 96,
          letterSpacing: 1,
          color: globals.primaryDarkColor,
        ),
        titleMedium: GoogleFonts.ubuntu(
          fontSize: 48,
          letterSpacing: 1.5,
          color: globals.primaryDarkColor,
        ),
        titleSmall: GoogleFonts.ubuntu(
          fontSize: 24,
          letterSpacing: 2,
          color: globals.primaryDarkColor,
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          letterSpacing: 2,
          color: globals.primaryDarkColor,
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 12,
          letterSpacing: 2,
          color: globals.primaryDarkColor,
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 8,
          letterSpacing: 2,
          color: globals.primaryDarkColor,
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 16,
          letterSpacing: 2,
          color: globals.primaryDarkColor.withAlpha(200),
        ),
        labelMedium: GoogleFonts.roboto(
          fontSize: 12,
          letterSpacing: 2,
          color: globals.primaryDarkColor.withAlpha(200),
        ),
        labelSmall: GoogleFonts.roboto(
          fontSize: 8,
          letterSpacing: 2,
          color: globals.primaryDarkColor.withAlpha(200),
        ),
      ),
    );
  }
}
