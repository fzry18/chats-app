import 'package:chatapp/app/data/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Container(
            width: screenWidth * 0.75,
            height: screenWidth * 0.75,
            child: Lottie.asset('assets/lottie/loading.json'),
          ),
        ),
      ),
    );
  }
}
