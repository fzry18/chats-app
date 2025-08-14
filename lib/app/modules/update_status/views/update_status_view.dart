import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_status_controller.dart';

class UpdateStatusView extends GetView<UpdateStatusController> {
  final authC = Get.find<AuthController>();

  UpdateStatusView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.updateStatusController.text = authC.userModel.value.status ?? '';
    return Obx(() => Scaffold(
          backgroundColor: AppColors.bgPrimary,
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
                            'Update Status',
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

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      SizedBox(height: 40),

                      // Status illustration
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),

                      SizedBox(height: 40),

                      Text(
                        'Tell everyone what\'s on your mind',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32),

                      // Status Input Field
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.bgTertiary,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.08),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, top: 16, right: 20),
                              child: Text(
                                'Status',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextField(
                              controller: controller.updateStatusController,
                              cursorColor: AppColors.primary,
                              maxLines: 4,
                              minLines: 3,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Apa yang sedang kamu pikirkan?',
                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 8, 20, 20),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 32),

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
                            authC.updateStatus(
                                controller.updateStatusController.text);
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

                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
