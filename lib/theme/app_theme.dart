import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilo de título.
TextStyle appHeading({double size = 20, Color color = AppColors.charcoal, FontWeight weight = FontWeight.w700}) {
  return GoogleFonts.oswald(
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: 0.2,
  );
}

/// Estilo de texto de cuerpo.
TextStyle appBody({double size = 13, Color color = AppColors.charcoal, FontWeight weight = FontWeight.w500}) {
  return GoogleFonts.manrope(
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.paper,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      primary: AppColors.orange,
      secondary: AppColors.caution,
      surface: AppColors.paper,
    ),
    textTheme: GoogleFonts.manropeTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.paper,
      foregroundColor: AppColors.charcoal,
      elevation: 0,
      titleTextStyle: appHeading(size: 19),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        foregroundColor: AppColors.paper,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: appHeading(size: 13, color: AppColors.paper),
      ),
    ),
  );
}
