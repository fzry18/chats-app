import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/data/styles/message_status.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:chatapp/utils/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Obx(() => Scaffold(
          backgroundColor: AppColors.bgSecondary,
          body: SafeArea(
            child: Column(
              children: [
                // Header with Search and Profile
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            onChanged: (value) {
                              // Search functionality will filter in real-time
                            },
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.textMuted,
                              ),
                              suffixIcon: Obx(
                                  () => controller.searchQuery.value.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.clear,
                                            color: AppColors.textMuted,
                                          ),
                                          onPressed: () {
                                            controller.clearSearch();
                                          },
                                        )
                                      : SizedBox()),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      // Profile Picture
                      GestureDetector(
                        onTap: () => Get.toNamed(Routes.PROFILE),
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.5),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.2),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.5),
                            child: controller.authC.userModel.value.photoUrl ==
                                    "noimage"
                                ? Container(
                                    color: AppColors.primary,
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.white,
                                      size: 24,
                                    ),
                                  )
                                : Image.network(
                                    controller.authC.userModel.value.photoUrl!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Users Section
                Container(
                  height: 100,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller
                        .chatsStream(controller.authC.userModel.value.email!),
                    builder: (context, chatSnapshot) {
                      if (!chatSnapshot.hasData ||
                          chatSnapshot.data!.docs.isEmpty) {
                        return SizedBox();
                      }

                      var chats = chatSnapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: chats.length > 5
                            ? 5
                            : chats.length, // Limit to 5 active users
                        itemBuilder: (context, index) {
                          var chatData = chats[index].data();
                          var friendEmail = (chatData['connections'] as List)
                              .where((element) =>
                                  element !=
                                  controller.authC.userModel.value.email)
                              .first;

                          return StreamBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            stream: controller.friendStream(friendEmail),
                            builder: (context, friendSnapshot) {
                              if (!friendSnapshot.hasData) {
                                return SizedBox();
                              }

                              var friendData = friendSnapshot.data!.data()!;

                              return Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 3,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(27),
                                        child:
                                            friendData['photoUrl'] == "noimage"
                                                ? Container(
                                                    color: AppColors.primary
                                                        .withOpacity(0.1),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: AppColors.primary,
                                                      size: 28,
                                                    ),
                                                  )
                                                : Image.network(
                                                    friendData['photoUrl'],
                                                    fit: BoxFit.cover,
                                                  ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      friendData['name']
                                          .toString()
                                          .split(' ')
                                          .first,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                // Chat/Status Toggle (replacing Groups with Status)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Chats',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 45,
                          child: Center(
                            child: Text(
                              'Status',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Recent Chats Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'RECENT CHATS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Chat List
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: controller
                          .chatsStream(controller.authC.userModel.value.email!),
                      builder: (context, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: SplashScreen(),
                          );
                        }

                        if (!chatSnapshot.hasData ||
                            chatSnapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  'assets/lottie/no-chat.json',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No chats yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Start a new conversation',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        var chats = chatSnapshot.data!.docs;
                        // Sort chats by lastTime
                        chats.sort((a, b) {
                          var timeA = a.data()['last_Time'] ?? '';
                          var timeB = b.data()['last_Time'] ?? '';
                          return timeB.compareTo(timeA);
                        });

                        return Obx(() {
                          // Filter chats based on search query
                          var searchQuery =
                              controller.searchQuery.value.toLowerCase();
                          var displayChats = chats;

                          if (searchQuery.isNotEmpty) {
                            displayChats = chats.where((chat) {
                              var chatData = chat.data();
                              var lastMessage = (chatData['lastMessage'] ?? '')
                                  .toString()
                                  .toLowerCase();
                              return lastMessage.contains(searchQuery);
                            }).toList();
                          }

                          if (displayChats.isEmpty && searchQuery.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: AppColors.textMuted,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No results found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Try a different search term',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.only(top: 15),
                            physics: BouncingScrollPhysics(),
                            itemCount: displayChats.length,
                            itemBuilder: (context, index) {
                              var chatData = displayChats[index].data();
                              var chatId = displayChats[index].id;
                              var friendEmail = (chatData['connections']
                                      as List)
                                  .where((element) =>
                                      element !=
                                      controller.authC.userModel.value.email)
                                  .first;

                              return StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: controller.friendStream(friendEmail),
                                builder: (context, friendSnapshot) {
                                  if (friendSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                AppColors.bgTertiary,
                                            child: CircularProgressIndicator(
                                              color: AppColors.primary,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            'Loading...',
                                            style: TextStyle(
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  if (!friendSnapshot.hasData) {
                                    return SizedBox();
                                  }

                                  var friendData = friendSnapshot.data!.data()!;

                                  // Additional filter by friend name if searching
                                  var searchQuery = controller.searchQuery.value
                                      .toLowerCase();
                                  if (searchQuery.isNotEmpty) {
                                    var friendName = (friendData['name'] ?? '')
                                        .toString()
                                        .toLowerCase();
                                    var lastMessage =
                                        (chatData['lastMessage'] ?? '')
                                            .toString()
                                            .toLowerCase();

                                    if (!friendName.contains(searchQuery) &&
                                        !lastMessage.contains(searchQuery)) {
                                      return SizedBox(); // Hide this chat if it doesn't match
                                    }
                                  }

                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.05),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      leading: Stack(
                                        children: [
                                          Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withOpacity(0.2),
                                                width: 2,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              child: friendData['photoUrl'] ==
                                                      "noimage"
                                                  ? Container(
                                                      color: AppColors.primary
                                                          .withOpacity(0.1),
                                                      child: Icon(
                                                        Icons.person,
                                                        color:
                                                            AppColors.primary,
                                                        size: 28,
                                                      ),
                                                    )
                                                  : Image.network(
                                                      friendData['photoUrl'],
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          // Online indicator
                                          Positioned(
                                            bottom: 2,
                                            right: 2,
                                            child: Container(
                                              width: 14,
                                              height: 14,
                                              decoration: BoxDecoration(
                                                color: AppColors.success,
                                                border: Border.all(
                                                  color: AppColors.white,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text(
                                        friendData['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: controller.streamChat(chatId),
                                        builder: (context, chatDocSnapshot) {
                                          if (!chatDocSnapshot.hasData) {
                                            return Text(
                                              'No messages yet',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 14,
                                              ),
                                            );
                                          }

                                          var chatDoc =
                                              chatDocSnapshot.data!.data();
                                          if (chatDoc == null ||
                                              chatDoc['chat'] == null ||
                                              (chatDoc['chat'] as List)
                                                  .isEmpty) {
                                            return Text(
                                              'No messages yet',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 14,
                                              ),
                                            );
                                          }

                                          var chatList =
                                              chatDoc['chat'] as List;
                                          var lastMessage = chatList.last;
                                          var isFromMe =
                                              lastMessage['pengirim'] ==
                                                  controller.authC.userModel
                                                      .value.email;
                                          var isRead =
                                              lastMessage['isRead'] ?? false;
                                          var messageText =
                                              lastMessage['pesan'] ??
                                                  'No messages yet';

                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  messageText,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              // Status indicator for sent messages
                                              MessageStatus
                                                  .getChatListStatusIcon(
                                                isFromMe: isFromMe,
                                                isRead: isRead,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      trailing: StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                        stream: controller.userStream(controller
                                            .authC.userModel.value.email!),
                                        builder: (context, userSnapshot) {
                                          if (userSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox();
                                          }

                                          if (!userSnapshot.hasData) {
                                            return SizedBox();
                                          }

                                          var userData =
                                              userSnapshot.data!.data()!;
                                          var userChats =
                                              userData['chats'] as List? ?? [];
                                          var currentChat =
                                              userChats.firstWhere(
                                            (element) =>
                                                element['chat_id'] == chatId,
                                            orElse: () => {'total_unread': 0},
                                          );

                                          int totalUnread =
                                              currentChat['total_unread'] ?? 0;

                                          return totalUnread > 0
                                              ? Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    '$totalUnread',
                                                    style: TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox();
                                        },
                                      ),
                                      onTap: () => Get.toNamed(
                                        Routes.CHAT_ROOM,
                                        arguments: {
                                          "chat_id": chatId,
                                          "friendEmail": friendEmail,
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
