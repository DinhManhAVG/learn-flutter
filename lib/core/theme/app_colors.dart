import 'package:flutter/material.dart';

/// App color constants for consistent theming
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryDark = Color(0xFF1A1F3A);
  static const Color primaryMedium = Color(0xFF2D3561);
  static const Color primaryLight = Color(0xFF4A5080);

  // Accent Colors
  static const Color accentBlue = Color(0xFF6366F1);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentPink = Color(0xFFEC4899);

  // Background & Surface
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0x1AFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF);
  static const Color textTertiary = Color(0x80FFFFFF);
  static const Color textDark = Color(0xFF1A1F3A);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
  ];

  static const List<Color> backgroundGradient = [
    Color(0xFF1A1F3A),
    Color(0xFF2D3561),
    Color(0xFF4A5080),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
  ];

  // Glass Effect
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
}
