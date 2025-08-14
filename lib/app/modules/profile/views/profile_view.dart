import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/controllers/theme_controller.dart';
import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          // Header with gradient background
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // App Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: AppColors.white),
                          onPressed: () => Get.back(),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.logout_rounded,
                              color: AppColors.white),
                          onPressed: () {
                            authController.logout();
                          },
                        ),
                      ],
                    ),
                  ),

                  // Profile Section
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      children: [
                        // Profile Picture with Glow Effect
                        AvatarGlow(
                          endRadius: 80,
                          glowColor: AppColors.white,
                          duration: const Duration(seconds: 2),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: AppColors.white,
                              border: Border.all(
                                color: AppColors.white,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(56),
                              child: authController.userModel.value.photoUrl ==
                                      "noimage"
                                  ? Container(
                                      color: AppColors.primaryLight,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Image.network(
                                      authController.userModel.value.photoUrl ??
                                          '',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Name
                        Obx(() => Text(
                              authController.userModel.value.name ??
                                  "User Name",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(height: 8),

                        // Email
                        Text(
                          authController.userModel.value.email ??
                              "user.name@example.com",
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  // Change Profile
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                    child: ListTile(
                      onTap: () {
                        Get.toNamed(Routes.CHANGE_PROFILE);
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "Change Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Update Status
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                    child: ListTile(
                      onTap: () {
                        Get.toNamed(Routes.UPDATE_STATUS);
                      },
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "Update Status",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),

                  // Change Theme
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Obx(() => ListTile(
                          onTap: () {
                            themeController.toggleTheme();
                          },
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              themeController.isDarkMode.value
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            "Change Theme",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              themeController.currentThemeName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )),
                  ),

                  Spacer(),

                  // App Info
                  Container(
                    margin: EdgeInsets.only(
                      bottom: context.mediaQueryPadding.bottom + 20,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Chat App",
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "v.1.0",
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
