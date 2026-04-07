import 'package:get/get.dart';

import '../controllers/profile_registration_controller.dart';

class ProfileRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRegistrationController>(
      () => ProfileRegistrationController(),
    );
  }
}
