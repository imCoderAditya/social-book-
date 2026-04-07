import 'package:get/get.dart';

import '../controllers/signup_verification_controller.dart';

class SignupVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupVerificationController>(
      () => SignupVerificationController(),
    );
  }
}
