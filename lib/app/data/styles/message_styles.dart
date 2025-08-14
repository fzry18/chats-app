import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class MessageBubbleStyle {
  MessageBubbleStyle._();

  // Style untuk pesan yang dikirim user
  static BoxDecoration sentMessageStyle = BoxDecoration(
    color: AppColors.msgSent,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
      bottomRight: Radius.circular(4),
    ),
  );

  // Style untuk pesan yang diterima
  static BoxDecoration receivedMessageStyle = BoxDecoration(
    color: AppColors.msgReceived,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(16),
    ),
  );

  // Style untuk pesan sistem
  static BoxDecoration systemMessageStyle = BoxDecoration(
    color: AppColors.msgSystem,
    borderRadius: BorderRadius.circular(12),
  );

  // Text style untuk pesan yang dikirim
  static TextStyle sentMessageTextStyle = TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Text style untuk pesan yang diterima
  static TextStyle receivedMessageTextStyle = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  // Text style untuk pesan sistem
  static TextStyle systemMessageTextStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  // Text style untuk timestamp
  static TextStyle timestampTextStyle = TextStyle(
    color: AppColors.textMuted,
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );

  // Text style untuk timestamp pada pesan yang dikirim
  static TextStyle sentTimestampTextStyle = TextStyle(
    color: AppColors.white.withOpacity(0.8),
    fontSize: 10,
    fontWeight: FontWeight.normal,
  );
}
