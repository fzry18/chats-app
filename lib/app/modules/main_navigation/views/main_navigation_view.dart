import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/modules/home/views/home_view.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({Key? key}) : super(key: key);

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomeView(key: ValueKey('home_in_navigation'));
      case 1:
        return _buildPlaceholderPage('Calls', Icons.phone, 'Coming Soon');
      case 2:
        return _buildPlaceholderPage(
            'Communities', Icons.people, 'Coming Soon');
      case 3:
        return _buildPlaceholderPage(
            'More', Icons.more_horiz, 'Settings & More');
      default:
        return HomeView(key: ValueKey('home_in_navigation_default'));
    }
  }

  Widget _buildPlaceholderPage(String title, IconData icon, String subtitle) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.primary.withOpacity(0.3),
            ),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [
      Icons.chat_bubble_outline,
      Icons.phone_outlined,
      Icons.people_outline,
      Icons.more_horiz,
    ];

    List<String> labelList = [
      'Chats',
      'Calls',
      'Communities',
      'More',
    ];

    return Scaffold(
      extendBody: true,
      body: Obx(() => _getPage(controller.currentIndex.value)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 8,
        onPressed: () => Get.toNamed(Routes.NEW_CHAT),
        child: Icon(
          Icons.add_comment_rounded,
          size: 24,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive ? AppColors.primary : AppColors.textMuted;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  iconList[index],
                  size: 24,
                  color: color,
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    labelList[index],
                    maxLines: 1,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                )
              ],
            );
          },
          backgroundColor: AppColors.bgPrimary,
          activeIndex: controller.currentIndex.value,
          splashColor: AppColors.primaryLight,
          splashSpeedInMilliseconds: 300,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          gapLocation: GapLocation.center,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => controller.changeTabIndex(index),
          shadow: BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 0.5,
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
