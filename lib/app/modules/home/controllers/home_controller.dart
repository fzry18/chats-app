import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final authC = Get.find<AuthController>();

  // Search functionality
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredChats =
      <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    filteredChats.clear();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore
        .collection('chats')
        .where('connections', arrayContains: email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamChat(String chatId) {
    return firestore.collection("chats").doc(chatId).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> friendStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }
}
