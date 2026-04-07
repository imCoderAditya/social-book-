import 'package:get/get.dart';

import '../controllers/switch_profile_controller.dart';

class SwitchProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwitchProfileController>(
      () => SwitchProfileController(),
    );
  }
}
