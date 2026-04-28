import 'package:flutter/material.dart';

/// Central color configuration for the Eatery Management System
/// All colors are defined here to ensure consistency across the app
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFCC00); // Eatery Yellow
  static const Color primaryLight = Color(0xFFF1C40F); // Light Yellow
  static const Color primaryDark = Color(0xFFD4AC0D); // Dark Yellow

  // Secondary Colors
  static const Color secondary = Color(0xFF333333); // Dark Black
  static const Color secondaryLight = Color(0xFF2C3E50); // Header Black

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF); // White
  static const Color black = Color(0xFF000000); // Black
  static const Color lightGray = Color(0xFFF4F4F4); // Light Gray
  static const Color mediumGray = Color(0xFFCCCCCC); // Medium Gray
  static const Color darkGray = Color(0xFF999999); // Dark Gray

  // Status Colors
  static const Color success = Color(0xFF27AE60); // Green
  static const Color error = Color(0xFFE74C3C); // Red
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color info = Color(0xFF3498DB); // Blue

  // Background Colors
  static const Color backgroundColor = Color(0xFFF4F4F4); // Light Gray
  static const Color surfaceColor = Color(0xFFFFFFFF); // White
  static const Color containerColor = Color(0xFFF9F9F9); // Very Light Gray

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0); // Light Border
  static const Color dividerColor = Color(0xFFF0F0F0); // Light Divider

  // Text Colors
  static const Color textPrimary = Color(0xFF333333); // Dark Text
  static const Color textSecondary = Color(0xFF666666); // Medium Text
  static const Color textLight = Color(0xFF999999); // Light Text
  static const Color textOnPrimary = Color(0xFF333333); // Text on Primary

  // Gradient Colors
  static const List<Color> gradientColors = [
    Color(0xFFFFCC00),
    Color(0xFFF1C40F),
  ];

  // Opacity values
  static const double opacityLight = 0.1;
  static const double opacityMedium = 0.5;
  static const double opacityHeavy = 0.8;

  /// Get color with custom opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Create a color from hex string
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (!hexString.startsWith('#')) buffer.write('#');
    buffer.write(hexString);
    return Color(int.parse(buffer.toString().replaceFirst('#', '0xff')));
  }
}
