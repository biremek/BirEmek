import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color secondaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color searchBackground = Color(0xFFEEEEEE);
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFF8F9FA);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF4D4D4D);
  
  // Icon Colors
  static const Color iconPrimary = Color(0xFF212121);
  static const Color iconSecondary = Color(0xFF666666);
  
  // Navigation Colors
  static const Color navigationBarColor = Color(0xFFF8F9FA);
  static const Color navigationBarBorderColor = Color(0xFFE0E0E0);
  static const Color navBackground = Color(0xFF1E88E5);
  static const Color navActive = primaryBlue;
  static const Color navInactive = Color(0xFFB3E5FC);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  // Other Colors
  static const Color white = Colors.white;
  static const Color black = Color(0xFF000000);
  static const Color shadowColor = Color(0x1A000000);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color green = Color(0xFF4CAF50);
  static const Color orange = Color(0xFFFFA726);
  static const Color pink = Color(0xFFE91E63);
  static const Color red = Color(0xFFE53935);
  static const Color lightPink = Color(0xFFFCE4EC);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, secondaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> blueGradient = [
    primaryBlue,
    secondaryBlue,
  ];
} 