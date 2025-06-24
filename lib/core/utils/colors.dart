import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color brandPrimary = Color(0xFF2C3E50); // Deep Blue-Gray
  static const Color brandSecondary = Color(0xFFE74C3C); // Vibrant Red
  static const Color brandAccent = Color(0xFFF39C12); // Golden Orange

  // Light Theme Colors
  static const Color primaryColor = Color(0xFF2C3E50); // Deep Blue-Gray
  static const Color secondaryColor = Color(0xFFE74C3C); // Vibrant Red
  static const Color accentColor = Color(0xFFF39C12); // Golden Orange
  static const Color background = Color(0xFFF5F6F8); // Light Gray-Blue
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFE53935); // Error Red
  static const Color success = Color(0xFF2ECC71); // Success Green
  static const Color warning = Color(0xFFF1C40F); // Warning Yellow

  // Light Theme Gradient for Buttons
  static const LinearGradient lightButtonGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme Gradient for Buttons
  static const LinearGradient darkButtonGradient = LinearGradient(
    colors: [primaryColorDark, accentColorDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50); // Deep Blue-Gray
  static const Color textSecondary = Color(0xFF7F8C8D); // Medium Gray
  static const Color textLight = Color(0xFFBDC3C7); // Light Gray

  // UI Element Colors
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFECF0F1); // Soft Gray
  static const Color shadowColor = Color(0x1A2C3E50);
  static const Color inputBorder = Color(0xFFD5DBDB); // Border Gray

  // Status Colors
  static const Color statusPending = Color(0xFFF39C12); // Orange
  static const Color statusDelivering = Color(0xFF3498DB); // Blue
  static const Color statusCompleted = Color(0xFF2ECC71); // Green
  static const Color statusCancelled = Color(0xFFE74C3C); // Red

  // Light Theme Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF2C3E50),
      Color(0xFF3498DB),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFE74C3C),
      Color(0xFFF39C12),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme Colors
  static const Color primaryColorDark = Color(0xFF1A252F); // Darker Blue-Gray
  static const Color secondaryColorDark = Color(0xFFC0392B); // Darker Red
  static const Color accentColorDark = Color(0xFFD35400); // Darker Orange
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceColorDark = Color(0xFF1E1E1E);
  static const Color errorDark = Color(0xFFCF6679);

  // Dark Theme Text Colors
  static const Color textPrimaryDark = Color(0xFFECF0F1); // Light Gray
  static const Color textSecondaryDark = Color(0xFFBDC3C7); // Medium Gray
  static const Color textLightDark = Color(0xFF95A5A6); // Darker Gray

  // Dark Theme UI Elements
  static const Color cardColorDark = Color(0xFF2C2C2C);
  static const Color dividerColorDark = Color(0xFF2C3E50);
  static const Color shadowColorDark = Color(0x3D000000);
  static const Color inputBorderDark = Color(0xFF34495E);

  // Dark Theme Gradients
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [
      Color(0xFF1A252F),
      Color(0xFF2980B9),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
 
  // Opacity Variants
  static Color getColorWithOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  // Shimmer Effect Colors
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Special Effects
  static const Color glassEffect = Color(0x0DFFFFFF);
  static const Color overlayDark = Color(0x99000000);
  static const Color overlayLight = Color(0x99FFFFFF);
}
