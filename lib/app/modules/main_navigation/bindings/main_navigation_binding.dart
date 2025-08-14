import 'package:get/get.dart';
import '../../home/bindings/home_binding.dart';

import '../controllers/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    // Register HomeBinding dependencies
    HomeBinding().dependencies();
  }
}
