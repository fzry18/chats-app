import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  const IntroductionView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColors.bgPrimary,
          body: IntroductionScreen(
            globalBackgroundColor: AppColors.bgPrimary,
            pages: [
              PageViewModel(
                image: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child: Center(
                    child: Lottie.asset('assets/lottie/main-laptop-duduk.json'),
                  ),
                ),
                titleWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Berinteraksi dengan mudah",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                bodyWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: Text(
                    "Anda dapat berinteraksi dengan pengguna lain dengan mudah dan nyaman.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              PageViewModel(
                image: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child: Center(
                    child: Lottie.asset('assets/lottie/connect-with-us.json'),
                  ),
                ),
                titleWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Temukan teman baru",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                bodyWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: Text(
                    "Jika Anda merasa kesepian, Anda dapat menemukan teman baru di sini.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              PageViewModel(
                image: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child:
                      Center(child: Lottie.asset('assets/lottie/pesawat.json')),
                ),
                titleWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Bergabung dengan komunitas",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                bodyWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: Text(
                    "Anda dapat bergabung dengan komunitas yang sesuai dengan minat Anda.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              PageViewModel(
                image: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child:
                      Center(child: Lottie.asset('assets/lottie/fitur.json')),
                ),
                titleWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Memiliki berbagai fitur",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ),
                bodyWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: Text(
                    "Aplikasi dilengkapi dengan berbagai fitur yang memudahkan interaksi.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              PageViewModel(
                image: Container(
                  width: Get.width * 0.6,
                  height: Get.width * 0.6,
                  child:
                      Center(child: Lottie.asset('assets/lottie/hello.json')),
                ),
                titleWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Mulai sekarang!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      height: 1.2,
                    ),
                  ),
                ),
                bodyWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: Text(
                    "Ayo bergabung dan mulai berinteraksi dengan pengguna lain sekarang juga!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
            onDone: () {
              Get.offAllNamed(Routes.LOGIN);
            },
            showSkipButton: true,
            skip: Text("Lewati",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  fontSize: 16,
                )),
            next: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text("Lanjut",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ),
            done: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Mulai",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: const Size.square(8.0),
              activeSize: const Size(20.0, 8.0),
              color: AppColors.textMuted.withOpacity(0.3),
              activeColor: AppColors.primary,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
            ),
          ),
        ));
  }
}
