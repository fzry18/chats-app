import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarUtils {
  // Success snackbar
  static void showSuccess({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      duration: duration,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  // Error snackbar
  static void showError({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 4),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: AppColors.error,
      colorText: Colors.white,
      duration: duration,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: AppColors.error.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  // Warning snackbar
  static void showWarning({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: AppColors.warning,
      colorText: Colors.white,
      duration: duration,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.warning_amber_outlined,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: AppColors.warning.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  // Info snackbar
  static void showInfo({
    required String title,
    required String message,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: AppColors.info,
      colorText: Colors.white,
      duration: duration,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      icon: Icon(
        Icons.info_outline,
        color: Colors.white,
        size: 24,
      ),
      shouldIconPulse: false,
      boxShadows: [
        BoxShadow(
          color: AppColors.info.withOpacity(0.3),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
