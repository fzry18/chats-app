import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/new_chat_controller.dart';

class NewChatView extends GetView<NewChatController> {
  final AuthController authC = Get.find<AuthController>();

  NewChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Start New Chat',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // To balance the back button
                  ],
                ),
              ),
            ),
          ),

          // Search Section
          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                controller.searchFriend(value);
              },
              controller: controller.searchController,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                hintText: "Search people...",
                hintStyle: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 24,
                ),
                suffixIcon: controller.searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.tempSearch.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Results Section
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            child: Lottie.asset(
                              'assets/lottie/loading.json',
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Searching...',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : controller.tempSearch.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: Get.width * 0.5,
                                height: Get.width * 0.5,
                                child: Lottie.asset('assets/lottie/empty.json'),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Try searching with a different email',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
                          physics: BouncingScrollPhysics(),
                          itemCount: controller.tempSearch.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                leading: Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(26),
                                    child: controller.tempSearch[index]
                                                ['photoUrl'] ==
                                            "noimage"
                                        ? Container(
                                            color: AppColors.primaryLight,
                                            child: Icon(
                                              Icons.person,
                                              size: 28,
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : Image.network(
                                            controller.tempSearch[index]
                                                ['photoUrl'],
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                title: Text(
                                  controller.tempSearch[index]['name'] ??
                                      'User ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Text(
                                    controller.tempSearch[index]['email'] ??
                                        'orang${index + 1}@gmail.com',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                trailing: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        authC.newChatConnection(
                                          controller.tempSearch[index]['email'],
                                        );
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 8,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.chat_bubble_outline,
                                              color: AppColors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Chat',
                                              style: TextStyle(
                                                color: AppColors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
