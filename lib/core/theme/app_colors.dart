import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // LEGACY DESIGN SYSTEM (KEPT IN COMMENTS FOR REFERENCE)
  // ===========================================================================
  // static const Color background = Color(0xFF111111);
  // static const Color surface = Color(0xFF1A1A1A);
  // static const Color surfaceHover = Color(0xFF2A2A2A);
  // static const Color border = Color(0xFF2C2C2E);
  // static const Color primaryAccent = Color(0xFFA3E635); // Lime Green
  // static const Color positive = Color(0xFF00E676);      // Green
  // static const Color negative = Color(0xFFFF3B30);      // Red
  // static const Color textPrimary = Color(0xFFFFFFFF);
  // static const Color textSecondary = Color(0xFF8E8E93);
  // static const Color divider = Color(0xFF2C2C2E);
  // ===========================================================================

  // ===========================================================================
  // NEW ANALYZED COLOR PALETTE (BITGET WALLET DARK MODE DESIGN SYSTEM)
  // ===========================================================================
  // 1. Background & Surface Container Colors:
  // - background: #131718 (Deep Dark Charcoal / Slate Black)
  // - surface: #1D2122 (Dark Gray Card & Module Background)
  // - surfaceHover: #1A2F37 (Deep Dark Cyan Slate for Active/Selected Pills & Cards)
  // - border: #25292A (Subtle Dark Slate Border)
  static const Color background = Color(0xFF131718);
  static const Color surface = Color(0xFF1D2122);
  static const Color surfaceHover = Color(0xFF1A2F37);
  static const Color border = Color(0xFF25292A);

  // 2. Primary Action / Accent Button Color:
  // - primaryAccent: #68E3F3 (Electric Cyan / Vivid Aqua Teal)
  static const Color primaryAccent = Color(0xFF68E3F3);

  // 3. Profit (Gain) & Loss Nominal Indicators:
  // - positive: #49A4C5 (Bright Sky Cyan Blue for + Gain / Profit)
  // - negative: #DD477A (Vivid Magenta Pink / Rose Red for - Loss)
  static const Color positive = Color(0xFF49A4C5);
  static const Color negative = Color(0xFFDD477A);

  // 4. Typography & Divider Palette:
  // - textPrimary: #FFFFFF (Pure White for Nominal Values & Main Headings)
  // - textSecondary: #7E8B93 (Muted Slate Gray for Subtitles & Secondary Info)
  // - divider: #25292A (Dark Slate Divider Line)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF7E8B93);
  static const Color divider = Color(0xFF25292A);
}
