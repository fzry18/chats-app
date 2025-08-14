import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class StatusColors {
  StatusColors._();

  // Online status
  static Color get online => AppColors.success;
  static Color get offline => AppColors.textMuted;
  static Color get away => AppColors.warning;

  // Message status
  static Color get sent => AppColors.textMuted;
  static Color get delivered => AppColors.primary;
  static Color get read => AppColors.primary;

  // Connection status
  static Color get connected => AppColors.success;
  static Color get connecting => AppColors.warning;
  static Color get disconnected => AppColors.error;

  // Typing indicator
  static Color get typing => AppColors.primary;

  // Helper methods untuk mendapatkan color berdasarkan status
  static Color getOnlineStatusColor(bool isOnline) {
    return isOnline ? online : offline;
  }

  static Color getMessageStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return sent;
      case 'delivered':
        return delivered;
      case 'read':
        return read;
      default:
        return sent;
    }
  }

  static Color getConnectionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return connected;
      case 'connecting':
        return connecting;
      case 'disconnected':
        return disconnected;
      default:
        return disconnected;
    }
  }
}
