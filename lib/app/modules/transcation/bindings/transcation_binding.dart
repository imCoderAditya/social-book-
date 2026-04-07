import 'package:get/get.dart';

import '../controllers/transcation_controller.dart';

class TranscationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TranscationController>(
      () => TranscationController(),
    );
  }
}
