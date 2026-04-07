import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/profile/profile_type_model.dart';
import 'package:social_book/app/routes/app_pages.dart';

import 'package:social_book/app/services/storage/local_storage_service.dart';

class SwitchProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;
  RxnInt selectedProfileProfileId = RxnInt();
  RxnInt selectedProfileIndex = RxnInt();

  Rxn<ProfileTypeModel> profileTypeModel = Rxn<ProfileTypeModel>();
  Rxn<ProfileType> selectedProfileType = Rxn<ProfileType>();

  @override
  void onInit() {
    fetchProfileType();

    super.onInit();
  }

  Future<void> fetchProfileType() async {
    final userId = LocalStorageService.getUserId();
    isFetching.value = true;

    try {
      final res = await BaseClient.get(
        api: "${EndPoint.profilesStatus}/$userId",
      );

      if (res != null && res.statusCode == 200) {
        profileTypeModel.value = profileTypeModelFromJson(
          json.encode(res.data),
        );

        final getProfileId = LocalStorageService.getProfileId() ?? 1;
        final profileType = LocalStorageService.getProfileType() ?? "";
        log("getProfile====>${getProfileId.toString()}");
        log("getProfile====>${profileType.toString()}");
        if (getProfileId == 0 && profileType.isEmpty) {
          selectedProfileProfileId.value = getProfileId;
        } else {
          selectedProfileProfileId.value =
              profileTypeModel.value?.profiles?.firstOrNull?.profileId ?? 0;
        }
        selectedProfileType.value =
            profileTypeModel.value?.profiles?.firstOrNull;
        await switchProfile(0);
      } else {
        LoggerUtils.error("Failed : ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error:$e");
    } finally {
      isFetching.value = false;
      update();
    }
  }

  Future<void> switchProfile(int index) async {
    final profiles = profileTypeModel.value?.profiles;
    if (profiles == null && profiles?[index].profileId == null) {
      Get.toNamed(Routes.PROFILE_REGISTRATION);
    } else {
      final profile = profiles?[index];
      selectedProfileProfileId.value = profile?.profileId ?? 0;
      selectedProfileType.value = profile;
      selectedProfileIndex.value = index;

      LocalStorageService.setProfileType(profile?.type ?? "");
      LocalStorageService.setProfileId(profile?.profileId ?? 0);

      final getProfile = LocalStorageService.getProfileId();
      final profileType = LocalStorageService.getProfileType();
      LoggerUtils.debug("getProfile====>$getProfile");
      LoggerUtils.debug("profileType====>$profileType");
    }

    update();
  }

  // Get current profile color
  Color get currentProfileColor {
    final colorStr = selectedProfileType.value?.color;
    if (colorStr != null && colorStr.isNotEmpty) {
      try {
        // Remove # if present and parse hex color
        final hexColor = colorStr.replaceAll('#', '');
        log("Primary Color: $hexColor");
        LocalStorageService.setPrimaryColor(hexColor);
        return Color(int.parse('FF$hexColor', radix: 16));
      } catch (e) {
        LoggerUtils.error("Error parsing color: $e");
      }
    }
    return Color(0xFF677CE8); // Default color
  }
}
