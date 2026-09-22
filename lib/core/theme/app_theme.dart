import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryAccent,
      dividerColor: AppColors.divider,
      // =======================================================================
      // LEGACY TYPOGRAPHY CONFIGURATION (KEPT IN COMMENTS)
      // =======================================================================
      // fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      // textTheme: TextTheme(
      //   displayLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      //   displayMedium: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      //   displaySmall: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      //   headlineMedium: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      //   titleLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      //   bodyLarge: const TextStyle(color: AppColors.textPrimary),
      //   bodyMedium: const TextStyle(color: AppColors.textPrimary),
      //   bodySmall: const TextStyle(color: AppColors.textSecondary),
      //   labelLarge: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
      //   labelSmall: const TextStyle(color: AppColors.textSecondary),
      // ),
      // =======================================================================

      // =======================================================================
      // NEW TYPOGRAPHY CONFIGURATION (BITGET WALLET DESIGN SYSTEM)
      // =======================================================================
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: TextTheme(
        displayLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displayMedium: const TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
        displaySmall: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        headlineMedium: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
        titleLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.normal),
        bodyMedium: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.normal),
        bodySmall: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
        labelSmall: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    );
  }
}
