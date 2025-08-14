import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/data/styles/message_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/chat_room_controller.dart';
import 'package:flutter/foundation.dart' as foundation;

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (controller.isShowEmoji.isTrue) {
          controller.isShowEmoji.value = false;
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColors.bgSecondary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          leadingWidth: 100,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            borderRadius: BorderRadius.circular(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Icon(Icons.arrow_back, color: Colors.white),
                const SizedBox(width: 10),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamFriend(controller.friendEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryLight,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    }

                    var friendData = snapshot.data!.data()!;
                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.bgTertiary,
                      child: friendData["photoUrl"] == "noimage"
                          ? Image.asset(
                              'assets/logo/noimage.png',
                              fit: BoxFit.cover,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                friendData["photoUrl"],
                                fit: BoxFit.cover,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
          title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamFriend(controller.friendEmail),
            builder: (context, friendSnap) {
              if (friendSnap.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }

              var friendData = friendSnap.data!.data()!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendData["name"],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    friendData["status"] ?? "No status",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: controller.streamChat(controller.chatId),
                  builder: (context, chatSnap) {
                    if (chatSnap.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          width: 100,
                          height: 100,
                        ),
                      );
                    }

                    if (chatSnap.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning,
                                  size: 40, color: AppColors.error),
                              SizedBox(height: 10),
                              Text(
                                'Terjadi kesalahan saat memuat pesan',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.streamChat(controller.chatId);
                                },
                                child: Text(
                                  'Coba Lagi',
                                  style: TextStyle(color: AppColors.primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (!chatSnap.hasData || chatSnap.data?.data() == null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline,
                                  size: 40, color: Colors.grey[400]),
                              SizedBox(height: 10),
                              Text(
                                'Belum ada pesan',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    List listChat = (chatSnap.data!.data()
                            as Map<String, dynamic>)["chat"] ??
                        [];

                    String? currentDate;
                    return ListView.builder(
                      controller: controller.scrollC,
                      itemCount: listChat.length,
                      itemBuilder: (context, index) {
                        var chat = listChat[index];
                        bool isSender = chat["pengirim"] ==
                            controller.authC.userModel.value.email;

                        String messageDate = chat["groupTime"] ?? "";
                        Widget? dateGroup;
                        if (currentDate != messageDate) {
                          currentDate = messageDate;
                          dateGroup = Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.bgTertiary,
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    messageDate,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.bgTertiary,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          children: [
                            if (dateGroup != null) dateGroup,
                            ItemChat(
                              isSender: isSender,
                              msg: chat["pesan"],
                              time: chat["time"],
                              isRead: chat["isRead"] ?? false,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                bottom: context.mediaQuery.padding.bottom,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Emoji button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      onPressed: () {
                        controller.focusNode.unfocus();
                        controller.isShowEmoji.toggle();
                      },
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgSecondary,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.bgTertiary,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.chatC,
                        focusNode: controller.focusNode,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              // Handle attachment
                            },
                            icon: Icon(
                              Icons.attach_file,
                              color: AppColors.textMuted,
                              size: 22,
                            ),
                          ),
                        ),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Send button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (controller.chatC.text.trim().isNotEmpty) {
                            controller.newChat(
                              controller.chatId,
                              controller.friendEmail,
                              controller.chatC.text.trim(),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.send_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => (controller.isShowEmoji.isTrue)
                  ? Container(
                      height: 325,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          controller.addEmojiToChat(emoji.emoji);
                        },
                        onBackspacePressed: () {
                          controller.deleteEmoji();
                        },
                        config: Config(
                          height: 256,
                          checkPlatformCompatibility: false,
                          emojiViewConfig: EmojiViewConfig(
                            emojiSizeMax: 28 *
                                (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? 1.20
                                    : 1.0),
                            backgroundColor: AppColors.bgPrimary,
                          ),
                          viewOrderConfig: const ViewOrderConfig(
                            top: EmojiPickerItem.categoryBar,
                            middle: EmojiPickerItem.emojiView,
                            bottom: EmojiPickerItem.searchBar,
                          ),
                          skinToneConfig: const SkinToneConfig(),
                          categoryViewConfig: CategoryViewConfig(
                            backgroundColor: AppColors.bgSecondary,
                          ),
                          bottomActionBarConfig: const BottomActionBarConfig(
                            buttonIconColor: Colors.white,
                          ),
                          searchViewConfig: const SearchViewConfig(),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSender ? AppColors.primary : AppColors.msgReceived,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: isSender ? Radius.circular(20) : Radius.circular(6),
                bottomRight:
                    isSender ? Radius.circular(6) : Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.only(bottom: 4),
            constraints: BoxConstraints(maxWidth: Get.width * 0.75),
            child: Text(
              msg,
              style: TextStyle(
                color: isSender ? AppColors.white : AppColors.textPrimary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateTime.parse(time).toLocal().toString().substring(11, 16),
                style: TextStyle(
                  fontSize: 11,
                  color: isSender
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 6),
              // Show status icon for sent messages
              if (isSender)
                MessageStatus.getStatusIcon(
                  isFromMe: isSender,
                  isRead: isRead,
                  size: 16,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
