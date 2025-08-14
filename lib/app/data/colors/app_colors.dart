import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/app/controllers/theme_controller.dart';

class AppColors {
  // Private constructor untuk mencegah instantiation
  AppColors._();

  // Get theme controller
  static ThemeController get _themeController => Get.find<ThemeController>();
  static bool get isDarkMode => _themeController.isDarkMode.value;

  // Main Colors
  static Color get primary =>
      isDarkMode ? Color(0xFF4CAF50) : Color(0xFF00A86B);
  static Color get primaryLight =>
      isDarkMode ? Color(0xFF2E2E2E) : Color(0xFFE8F5E8);
  static Color get primaryDark =>
      isDarkMode ? Color(0xFF388E3C) : Color(0xFF00794D);

  // Backgrounds
  static Color get bgPrimary =>
      isDarkMode ? Color(0xFF121212) : Color(0xFFFFFFFF);
  static Color get bgSecondary =>
      isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFF8FBF8);
  static Color get bgTertiary =>
      isDarkMode ? Color(0xFF2E2E2E) : Color(0xFFF0F7F0);

  // Text
  static Color get textPrimary =>
      isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF1A1A1A);
  static Color get textSecondary =>
      isDarkMode ? Color(0xFFB3B3B3) : Color(0xFF666666);
  static Color get textMuted =>
      isDarkMode ? Color(0xFF888888) : Color(0xFF999999);

  // Accents
  static Color get accent => isDarkMode ? Color(0xFFFF6B35) : Color(0xFFFF5722);
  static Color get success =>
      isDarkMode ? Color(0xFF4CAF50) : Color(0xFF00A86B);
  static Color get warning =>
      isDarkMode ? Color(0xFFFFB74D) : Color(0xFFFF9800);
  static Color get error => isDarkMode ? Color(0xFFEF5350) : Color(0xFFF44336);
  static Color get info => isDarkMode ? Color(0xFF42A5F5) : Color(0xFF2196F3);

  // Message Bubbles
  static Color get msgSent =>
      isDarkMode ? Color(0xFF4CAF50) : Color(0xFF00A86B);
  static Color get msgReceived =>
      isDarkMode ? Color(0xFF2E2E2E) : Color(0xFFF5F5F5);
  static Color get msgSystem =>
      isDarkMode ? Color(0xFF1A237E) : Color(0xFFE3F2FD);

  // Additional helper colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // Gradient colors
  static LinearGradient get primaryGradient => LinearGradient(
        colors: [primary, primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get backgroundGradient => LinearGradient(
        colors: [bgPrimary, bgSecondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  // Dark mode specific colors
  static Color get cardBackground =>
      isDarkMode ? Color(0xFF2E2E2E) : Color(0xFFFFFFFF);
  static Color get divider =>
      isDarkMode ? Color(0xFF424242) : Color(0xFFE0E0E0);
  static Color get shadow => isDarkMode ? Colors.black54 : Colors.black12;
}
