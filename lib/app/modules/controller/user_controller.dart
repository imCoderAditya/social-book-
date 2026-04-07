import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';

class UserController extends GetxController {

  RxString? profileType="".obs;
  final profileController =
      Get.isRegistered<ProfileController>()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());

  Future<int?>? getProfileId() async{
    final profile = profileController.profileModel.value?.data;
    switch (profileType?.value) {
      case "Social":
        debugPrint("Social=>${profile?.profiles?[0].profileId.toString()}");
        return profile?.profiles?[0].profileId ?? 0;

      case "Professional":
        debugPrint(
          "Professional=>${profile?.profiles?[1].profileId.toString()}",
        );
        return profile?.profiles?[1].profileId ?? 0;
      case "Hidden":
        debugPrint("Hidden=>${profile?.profiles?[2].profileId.toString()}");
        return profile?.profiles?[2].profileId ?? 0;
      case "Matrimonial":
        debugPrint(
          "Matrimonial=>${profile?.profiles?[3].profileId.toString()}",
        );
        return profile?.profiles?[3].profileId ?? 0;
      default:
        return profile?.profiles?[0].profileId ?? 0;
    }
  }
}
