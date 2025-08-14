import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChangeProfileController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController statusController;
  late ImagePicker imagePicker;

  XFile? pickedImage = null;

  void selectImage() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print(pickedFile.name);
        pickedImage = pickedFile;
      }
      update();
    } catch (e) {
      print('Error selecting image: $e');
      pickedImage = null;
      update();
    }
  }

  void resetImage() {
    pickedImage = null;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    nameController = TextEditingController();
    statusController = TextEditingController();
    imagePicker = ImagePicker();
  }

  @override
  void onClose() {
    emailController.dispose();
    nameController.dispose();
    statusController.dispose();
    super.onClose();
  }
}
