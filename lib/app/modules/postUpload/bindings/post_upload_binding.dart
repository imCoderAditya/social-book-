import 'package:get/get.dart';

import '../controllers/post_upload_controller.dart';

class PostUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostUploadController>(
      () => PostUploadController(),
    );
  }
}
