import 'package:get/get.dart';

import '../controllers/matrimonial_controller.dart';

class MatrimonialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatrimonialController>(
      () => MatrimonialController(),
    );
  }
}
