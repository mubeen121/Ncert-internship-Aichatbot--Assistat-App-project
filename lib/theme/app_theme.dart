import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized color palette — ONLY red, black, and white/grey for text.
/// Every screen (splash, sidebar, chat) draws from this single source.
class AppColors {
  static const Color pureBlack = Color(0xFF0A0A0A);
  static const Color richBlack = Color(0xFF141414);
  static const Color charcoal = Color(0xFF1F1F1F);
  static const Color sidebarBlack = Color(0xFF161616);
  static const Color deepRed = Color(0xFF8B0000);
  static const Color crimson = Color(0xFFD32F2F);
  static const Color brightRed = Color(0xFFE53935);
  static const Color emberOrangeRed = Color(0xFFFF3B30);
  static const Color softWhite = Color(0xFFF5F5F5);
  static const Color mutedGrey = Color(0xFFB0B0B0);
  static const Color faintGrey = Color(0xFF7A7A7A);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pureBlack, richBlack, Color(0xFF1A0000), pureBlack],
    stops: [0.0, 0.35, 0.7, 1.0],
  );

  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [pureBlack, deepRed],
  );

  static const LinearGradient userBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [crimson, deepRed],
  );

  static const LinearGradient botBubbleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [charcoal, Color(0xFF2A2A2A)],
  );

  static const LinearGradient sendButtonGradient = LinearGradient(
    colors: [brightRed, deepRed],
  );

  // Logo gradient — used in splash, sidebar header, and welcome view
  static const RadialGradient logoGradient = RadialGradient(
    colors: [emberOrangeRed, deepRed, Color(0xFF3A0000)],
    stops: [0.0, 0.6, 1.0],
  );
}

class AppTheme {
  static ThemeData get themeData {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.pureBlack,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.crimson,
        secondary: AppColors.deepRed,
        surface: AppColors.richBlack,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.softWhite,
        displayColor: AppColors.softWhite,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.charcoal,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.mutedGrey),
      ),
    );
  }
}
