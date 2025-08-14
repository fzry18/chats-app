import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewChatController extends GetxController {
  late TextEditingController searchController;

  var queryAwal = [].obs;
  var tempSearch = [].obs;
  var isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String query) async {
    if (query.isEmpty) {
      tempSearch.value = [];
      return;
    }

    isLoading.value = true;
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    try {
      // Menggunakan index untuk mencari berdasarkan keyName (huruf pertama uppercase)
      var results = <Map<String, dynamic>>[];

      // 1. Cari exact match dengan keyName
      final keyNameQuery = await firestore
          .collection('users')
          .where('keyName', isEqualTo: query.toUpperCase())
          .where('email', isNotEqualTo: currentUserEmail)
          .get();

      results.addAll(keyNameQuery.docs.map((doc) => doc.data()));

      // 2. Jika tidak ada hasil atau query lebih dari 1 karakter, cari berdasarkan nama
      if (results.isEmpty && query.length > 1) {
        final nameQuery = await firestore
            .collection('users')
            .orderBy('_name_')
            .startAt([query.toLowerCase()])
            .endAt([query.toLowerCase() + '\uf8ff'])
            .where('email', isNotEqualTo: currentUserEmail)
            .get();

        results.addAll(nameQuery.docs.map((doc) => doc.data()));
      }

      // 3. Cari berdasarkan email jika masih belum ada hasil
      if (results.isEmpty && query.contains('@')) {
        final emailQuery = await firestore
            .collection('users')
            .orderBy('email')
            .startAt([query.toLowerCase()])
            .endAt([query.toLowerCase() + '\uf8ff'])
            .where('email', isNotEqualTo: currentUserEmail)
            .get();

        results.addAll(emailQuery.docs.map((doc) => doc.data()));
      }

      // Update hasil pencarian
      tempSearch.value = results;
      print("Search results: ${tempSearch.length}");
    } catch (e) {
      print("Error searching: $e");
    } finally {
      isLoading.value = false;
    }

    tempSearch.refresh();
  }

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
