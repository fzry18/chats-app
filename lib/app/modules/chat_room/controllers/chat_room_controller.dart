import 'dart:async';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/utils/snackbar_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatRoomController extends GetxController {
  var isShowEmoji = false.obs;
  var isLoading = true.obs;
  int total_unread = 0;

  // Friend data observables
  var friendName = "".obs;
  var friendStatus = "".obs;
  var friendPhoto = "noimage".obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authC = Get.find<AuthController>();

  late FocusNode focusNode;
  late TextEditingController chatC;
  late ScrollController scrollC;

  // Store chat room data
  late String chatId;
  late String friendEmail;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String chatId) {
    return firestore.collection("chats").doc(chatId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriend(
      String friendEmail) {
    return firestore.collection("users").doc(friendEmail).snapshots();
  }

  void addEmojiToChat(String emoji) {
    chatC.text = chatC.text + emoji;
  }

  void deleteEmoji() {
    if (chatC.text.isNotEmpty) {
      chatC.text = chatC.text.substring(0, chatC.text.length - 2);
    }
  }

  void toggleEmoji() async {
    if (isShowEmoji.isFalse) {
      focusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 50));
      isShowEmoji.value = true;
    } else {
      isShowEmoji.value = false;
      await Future.delayed(const Duration(milliseconds: 50));
      focusNode.requestFocus();
    }
  }

  void newChat(String chatId, String friendEmail, String message) async {
    if (message.isEmpty) return;

    try {
      CollectionReference chats = firestore.collection("chats");
      String date = DateTime.now().toIso8601String();

      final chatDoc = await chats.doc(chatId).get();
      if (chatDoc.exists) {
        final currentData = chatDoc.data() as Map<String, dynamic>;
        List<dynamic> existingChats = currentData["chat"] ?? [];

        // Add groupTime to message
        String groupTime =
            DateFormat.yMMMMd('en_US').format(DateTime.parse(date));

        // Create new message
        final newMessage = {
          "pengirim": authC.userModel.value.email,
          "penerima": friendEmail,
          "pesan": message,
          "time": date,
          "isRead": false,
          "groupTime": groupTime,
        };

        // Update chats collection
        await chats.doc(chatId).update({
          "chat": [...existingChats, newMessage],
          "lastMessage": message,
          "last_Time": date,
        });

        // Update receiver's total_unread
        final userDoc =
            await firestore.collection("users").doc(friendEmail).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          List<dynamic> userChats = userData["chats"] ?? [];

          int chatIndex =
              userChats.indexWhere((element) => element["chat_id"] == chatId);
          if (chatIndex != -1) {
            userChats[chatIndex]["total_unread"] =
                (userChats[chatIndex]["total_unread"] ?? 0) + 1;
            userChats[chatIndex]["lastTime"] = date;

            await firestore.collection("users").doc(friendEmail).update({
              "chats": userChats,
            });
          }
        }

        chatC.clear();
        await scrollC.animateTo(
          scrollC.position.maxScrollExtent + 100,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      print("ERROR ${e.toString()}");
      SnackbarUtils.showError(
        title: "Error",
        message: "Tidak dapat mengirim pesan.",
      );
    }
  }

  Future<void> loadFriendData() async {
    try {
      var friendDoc =
          await firestore.collection("users").doc(friendEmail).get();
      if (friendDoc.exists) {
        var data = friendDoc.data()!;
        friendName.value = data["name"] ?? "Unknown";
        friendStatus.value = data["status"] ?? "No status";
        friendPhoto.value = data["photoUrl"] ?? "noimage";
      }
      isLoading.value = false;
    } catch (e) {
      print("Error loading friend data: $e");
      isLoading.value = false;
    }
  }

  // Mark messages as read when chat is opened
  Future<void> markMessagesAsRead() async {
    try {
      var chatDoc = await firestore.collection("chats").doc(chatId).get();
      if (chatDoc.exists) {
        var chatData = chatDoc.data()!;
        List<dynamic> chatList = chatData["chat"] ?? [];

        bool hasUnreadMessages = false;

        // Mark messages from friend as read
        for (int i = 0; i < chatList.length; i++) {
          if (chatList[i]["penerima"] == authC.userModel.value.email &&
              chatList[i]["isRead"] == false) {
            chatList[i]["isRead"] = true;
            hasUnreadMessages = true;
          }
        }

        // Update chat document if there were unread messages
        if (hasUnreadMessages) {
          await firestore.collection("chats").doc(chatId).update({
            "chat": chatList,
          });
        }
      }
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  @override
  Future<void> onInit() async {
    // Initialize controllers
    chatC = TextEditingController();
    scrollC = ScrollController();
    focusNode = FocusNode();

    // Setup focus listener
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isShowEmoji.value = false;
      }
    });

    // Get chat room data from arguments with error handling
    try {
      if (Get.arguments is! Map<String, dynamic>) {
        throw "Arguments harus berupa Map<String, dynamic>";
      }

      final args = Get.arguments as Map<String, dynamic>;
      if (!args.containsKey("chat_id") || !args.containsKey("friendEmail")) {
        throw "Arguments harus memiliki chat_id dan friendEmail";
      }

      chatId = args["chat_id"];
      friendEmail = args["friendEmail"];

      // Load friend data
      await loadFriendData();

      // Mark messages as read when opening chat
      await markMessagesAsRead();

      // Reset total_unread when opening chat room
      try {
        final currentUserEmail = authC.userModel.value.email!;
        final userDoc =
            await firestore.collection("users").doc(currentUserEmail).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          List<dynamic> userChats = userData["chats"] ?? [];

          int chatIndex =
              userChats.indexWhere((element) => element["chat_id"] == chatId);
          if (chatIndex != -1) {
            userChats[chatIndex]["total_unread"] = 0;

            await firestore.collection("users").doc(currentUserEmail).update({
              "chats": userChats,
            });
          }
        }
      } catch (e) {
        print("Error resetting unread count: $e");
      }
    } catch (e) {
      print("Error in ChatRoomController: $e");
      Get.back();
      SnackbarUtils.showError(
        title: "Error",
        message: "Terjadi kesalahan saat membuka chat room",
      );
    }

    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    scrollC.dispose();
    focusNode.dispose();
    super.onClose();
  }
}
