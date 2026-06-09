import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ألوان وثيم التطبيق المركزي — مستخرجة من تصاميم الشاشات الأصلية.
class AppColors {
  AppColors._();

  static const Color surface = Color(0xFFFFFbFA);
  static const Color primary = Color(0xFF9C4250);
  static const Color primaryDark = Color(0xFF7D2B3A);
  static const Color primaryContainer = Color(0xFFFFD9DE);
  static const Color onPrimaryContainer = Color(0xFF7D2B3A);
  static const Color tertiary = Color(0xFF775930);
  static const Color tertiaryContainer = Color(0xFFB6D3AF);
  static const Color onTertiaryContainer = Color(0xFF435C3F);
  static const Color onSurface = Color(0xFF201A1B);
  static const Color onSurfaceVariant = Color(0xFF534345);
  static const Color surfaceContainerLow = Color(0xFFFCF0F1);
  static const Color outlineVariant = Color(0xFFD8C2C4);
  static const Color error = Color(0xFFB3261E);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.surface,
    );
    return base.copyWith(
      textTheme: GoogleFonts.notoSansArabicTextTheme(base.textTheme),
    );
  }
}
