import 'package:get/get.dart';

import '../controllers/profile_other_user_controller.dart';

class ProfileOtherUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileOtherUserController>(
      () => ProfileOtherUserController(),
    );
  }
}
