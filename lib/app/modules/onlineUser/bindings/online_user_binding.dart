import 'package:get/get.dart';

import '../controllers/online_user_controller.dart';

class OnlineUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnlineUserController>(
      () => OnlineUserController(),
    );
  }
}
