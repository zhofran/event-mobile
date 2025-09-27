import 'package:flutter/material.dart';

/// FabColors - Design tokens warna dari Figma untuk aplikasi Job Portal
/// Berisi semua warna yang digunakan dalam aplikasi untuk konsistensi design
class FabColors {
  FabColors._();

  // ===== PRIMARY COLORS (Orange) =====
  static const Color primary300 = Color(0xFFCF6A30);
  static const Color primary200 = Color(0xFFF97F3A);
  static const Color primary100 = Color(0xFFFBAA7C);
  static const Color primary50 = Color(0xFFFCBF9C);
  static const Color primary25 = Color(0xFFFDD4BD);
  static const Color primary0 = Color(0xFFFEE5D8);

  // Primary aliases untuk kemudahan penggunaan
  static const Color primary = primary200;
  static const Color primaryLight = primary100;
  static const Color primaryDark = primary300;

  // ===== GREYSCALE COLORS =====
  static const Color greyscale900 = Color(0xFF0D0D12);
  static const Color greyscale800 = Color(0xFF1A1B25);
  static const Color greyscale700 = Color(0xFF1B1B1B);
  static const Color greyscale600 = Color(0xFF36394A);
  static const Color greyscale500 = Color(0xFF666D80);
  static const Color greyscale400 = Color(0xFF818898);
  static const Color greyscale300 = Color(0xFFA4ACB9);
  static const Color greyscale200 = Color(0xFFC1C7D0);
  static const Color greyscale100 = Color(0xFFDFE1E7);
  static const Color greyscale50 = Color(0xFFECEFF3);
  static const Color greyscale25 = Color(0xFFF6F8FA);
  static const Color greyscale0 = Color(0xFFFFFFFF);

  // ===== ADDITIONAL SKY COLORS =====
  static const Color sky300 = Color(0xFF0C4E6E);
  static const Color sky200 = Color(0xFF116B97);
  static const Color sky100 = Color(0xFF33CFFF);
  static const Color sky50 = Color(0xFF7EDDF1);
  static const Color sky25 = Color(0xFFD1F0FA);
  static const Color sky0 = Color(0xFFF0FBFF);

  // ===== ALERT SUCCESS COLORS =====
  static const Color success300 = Color(0xFF134118);
  static const Color success200 = Color(0xFF278231);
  static const Color success100 = Color(0xFF3AC348);
  static const Color success50 = Color(0xFF7CD785);
  static const Color success25 = Color(0xFFBDEBC2);
  static const Color success0 = Color(0xFFECFFEE);

  // ===== ALERT ERROR COLORS =====
  static const Color error300 = Color(0xFF6C1F1F);
  static const Color error200 = Color(0xFF8F2929);
  static const Color error100 = Color(0xFFD73E3D);
  static const Color error50 = Color(0xFFED8296);
  static const Color error25 = Color(0xFFFADBE1);
  static const Color error0 = Color(0xFFFFF0F3);

  // ===== ALERT WARNING COLORS =====
  static const Color warning300 = Color(0xFF5C3D1F);
  static const Color warning200 = Color(0xFF966422);
  static const Color warning100 = Color(0xFFFFBE4C);
  static const Color warning50 = Color(0xFFFCDA83);
  static const Color warning25 = Color(0xFFFAEDCC);
  static const Color warning0 = Color(0xFFFFF6E0);

  // ===== SEMANTIC ALIASES =====
  // Background colors
  static const Color background = greyscale0;
  static const Color backgroundSecondary = greyscale25;
  static const Color backgroundTertiary = greyscale50;

  // Surface colors
  static const Color surface = greyscale0;
  static const Color surfaceSecondary = greyscale25;

  // Text colors
  static const Color textPrimary = greyscale900;
  static const Color textSecondary = greyscale700;
  static const Color textTertiary = greyscale500;
  static const Color textQuaternary = greyscale300;

  // System colors
  static const Color success = success100;
  static const Color warning = warning100;
  static const Color error = error100;
  static const Color info = sky100;

  // Border colors
  static const Color border = greyscale200;
  static const Color borderLight = greyscale100;

  // Shadow colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // Overlay colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Disabled colors
  static const Color disabled = greyscale300;
  static const Color disabledText = greyscale400;

  // Transparent
  static const Color transparent = Color(0x00000000);

  // E5E5E5
  static const Color line = Color(0xFFE5E5E5);
}