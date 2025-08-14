import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/data/styles/message_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemChat extends StatelessWidget {
  const ItemChat({
    required this.isSender,
    required this.msg,
    required this.time,
    this.isRead = false,
    super.key,
  });

  final bool isSender;
  final String msg;
  final String time;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSender ? AppColors.msgSent : AppColors.msgReceived,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: isSender ? Radius.circular(15) : Radius.circular(4),
                bottomRight:
                    isSender ? Radius.circular(4) : Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 3,
                  offset: Offset(0, 2),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: EdgeInsets.only(bottom: 3),
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            child: Text(
              msg,
              style: TextStyle(
                color: isSender ? AppColors.white : AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateTime.parse(time).toLocal().toString().substring(11, 16),
                style: TextStyle(
                  fontSize: 10,
                  color: isSender
                      ? AppColors.white.withOpacity(0.8)
                      : AppColors.textMuted,
                ),
              ),
              SizedBox(width: 4),
              // Show status icon for sent messages
              if (isSender)
                MessageStatus.getStatusIcon(
                  isFromMe: isSender,
                  isRead: isRead,
                  size: 12,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
