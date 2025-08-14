import 'package:flutter/material.dart';

class MessageStatus {
  // Private constructor
  MessageStatus._();

  /// Returns appropriate status icon for message
  static Widget getStatusIcon({
    required bool isFromMe,
    required bool isRead,
    double size = 18,
  }) {
    if (!isFromMe) {
      // If message is not from me, don't show any status
      return SizedBox();
    }

    return Container(
      child: isRead
          ? Icon(
              Icons.done_all, // Double check mark (✓✓)
              size: size,
              color: Colors.blue[600], // Blue for read (WhatsApp style)
            )
          : Icon(
              Icons.done, // Single check mark (✓)
              size: size,
              color: Colors.grey[500], // Gray for delivered/unread
            ),
    );
  }

  /// Returns status icon for chat list (last message status)
  static Widget getChatListStatusIcon({
    required bool isFromMe,
    required bool isRead,
    double size = 16,
  }) {
    if (!isFromMe) {
      // If last message is not from me, don't show any status
      return SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: isRead
          ? Icon(
              Icons.done_all, // Double check mark (✓✓)
              size: size,
              color: Colors.blue[600], // Blue for read (WhatsApp style)
            )
          : Icon(
              Icons.done, // Single check mark (✓)
              size: size,
              color: Colors.grey[500], // Gray for delivered/unread
            ),
    );
  }

  /// Returns text description of message status
  static String getStatusText({
    required bool isFromMe,
    required bool isRead,
  }) {
    if (!isFromMe) {
      return '';
    }

    return isRead ? 'Read' : 'Delivered';
  }
}
