import 'dart:developer';
import 'package:get/get.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/imagePick/insta_picker_service.dart';

class SocialController extends GetxController {
  var selectIndex = 1.obs;

  var isLoading = false.obs;

  RxList<InstaAssetsExportData> selectedMedia = <InstaAssetsExportData>[].obs;

  void pickImages() {
    InstaPickerService.pickMedia(
      onCompleted: (stream) {
        Get.back();
        stream.listen((details) {
          selectedMedia.assignAll(details.data);
        });

        log("selectedMedia ${selectedMedia.length.toString()}");
        Get.toNamed(Routes.MEDIA_PREVIEW);
      },
    );
  }

  void removeImage(int index) {
    selectedMedia.removeAt(index);
  }
}
