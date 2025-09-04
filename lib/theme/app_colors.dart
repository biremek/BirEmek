import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color secondaryBlue = Color(0xFF64B5F6);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E88E5),
      Color(0xFF64B5F6),
    ],
  );
  
  // Text Colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textMedium = Color(0xFF424242);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  
  // Border Colors
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardBorder = Color(0xFFE0E0E0);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color background = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color white = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  // Additional Colors
  static const Color green = Color(0xFF4CAF50);
  static const Color orange = Color(0xFFFFA726);
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color navBackground = Color(0xFFF8F9FA);
  static const Color iconPrimary = Color(0xFF1E88E5);
  static const Color iconSecondary = Color(0xFF757575);
} 