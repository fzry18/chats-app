import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/controllers/theme_controller.dart';
import 'package:chatapp/app/data/themes/app_themes.dart';
import 'package:chatapp/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();

  final authC = Get.put(AuthController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  // Tunggu firstInitialized selesai sebelum menjalankan app
  await authC.firstInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final authC = Get.find<AuthController>();
  final themeC = Get.find<ThemeController>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Hanya delay untuk splash screen
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        // Tampilkan splash screen selama delay
        if (snapshot.connectionState != ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        // Setelah delay, tampilkan app dengan rute yang sesuai
        return Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat App',
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: themeC.themeMode,
            initialRoute: authC.isSkipIntroduction.isTrue
                ? authC.isAuthenticated.isTrue
                    ? Routes.HOME
                    : Routes.LOGIN
                : Routes.INTRODUCTION,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
