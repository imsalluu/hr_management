import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Soft Yellow primary color
  static const Color primaryColor = Color(0xFFFFC107);
  
  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: primaryColor,
      primaryContainer: Color(0xFFFFECB3),
      secondary: Colors.white, // Darker secondary for contrast
      secondaryContainer: Color(0xFFCFD8DC),
      tertiary: Color(0xFFFDD835),
      tertiaryContainer: Color(0xFFFFF9C4),
      appBarColor: Colors.white,
      error: Color(0xFFB00020),
    ),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 0, // No blending for a pure white background
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 0,
      blendOnColors: false,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      inputDecoratorRadius: 12,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      inputDecoratorUnfocusedBorderIsColored: false,
      elevatedButtonRadius: 10,
      outlinedButtonRadius: 10,
      cardRadius: 16,
      cardElevation: 0,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
    scaffoldBackground: Colors.white,
  );

  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.amber,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 13,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      inputDecoratorRadius: 12,
      elevatedButtonRadius: 10,
      outlinedButtonRadius: 10,
      cardRadius: 16,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
}
