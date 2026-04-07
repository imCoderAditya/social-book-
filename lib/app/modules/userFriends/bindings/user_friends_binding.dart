import 'package:get/get.dart';

import '../controllers/user_friends_controller.dart';

class UserFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserFriendsController>(
      () => UserFriendsController(),
    );
  }
}
