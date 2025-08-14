import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final authController = Get.find<AuthController>();

  ChangeProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.emailController.text =
        authController.userModel.value.email ?? '';
    controller.nameController.text = authController.userModel.value.name ?? '';
    controller.statusController.text =
        authController.userModel.value.status ?? '';
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
                        Expanded(
                          child: Text(
                            'Change Profile',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.save_alt_outlined,
                              color: AppColors.white),
                          onPressed: () {
                            authController.changeProfile(
                              controller.nameController.text,
                              controller.statusController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Profile Picture Section
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: AvatarGlow(
                      endRadius: 80,
                      glowColor: AppColors.white,
                      duration: const Duration(seconds: 2),
                      child: Obx(() => Container(
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
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form Section
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              child: ListView(
                children: [
                  // Email Field (Read Only)
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                      readOnly: true,
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter your email here',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        filled: true,
                        fillColor: AppColors.bgTertiary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),

                  // Name Field
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                      textInputAction: TextInputAction.next,
                      controller: controller.nameController,
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter your name here',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Status Field
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
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
                      textInputAction: TextInputAction.done,
                      controller: controller.statusController,
                      cursorColor: AppColors.primary,
                      onEditingComplete: () => authController.changeProfile(
                        controller.nameController.text,
                        controller.statusController.text,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Status',
                        labelStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: 'Enter your status here',
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        prefixIcon: Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  // Image Selection Section
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(bottom: 20),
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
                    child: Row(
                      children: [
                        Expanded(
                          child: GetBuilder<ChangeProfileController>(
                            builder: (c) => c.pickedImage != null
                                ? Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                          image: DecorationImage(
                                            image: FileImage(
                                              File(c.pickedImage!.path),
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              c.resetImage();
                                            },
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: AppColors.error,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Upload',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Icon(
                                        Icons.image_outlined,
                                        size: 48,
                                        color: AppColors.textMuted,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "No image selected",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.selectImage();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              foregroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            child: Text(
                              'Choose',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Update Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        authController.changeProfile(
                          controller.nameController.text,
                          controller.statusController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
