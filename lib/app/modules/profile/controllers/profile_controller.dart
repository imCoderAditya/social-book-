import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:image_picker/image_picker.dart';
import 'package:social_book/app/components/comman_image_picker.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/post/my_post_model.dart';
import 'package:social_book/app/data/models/profile/profile_model.dart';
import 'package:social_book/app/data/models/profile/user_profile_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class ProfileController extends GetxController {
  ScrollController myPostScrollController = ScrollController();
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<UserProfileModel> userProfileModel = Rxn<UserProfileModel>();
  Rxn<MyPostModel> myPostModel = Rxn<MyPostModel>();
  RxList<MyPostData> myPostList = RxList<MyPostData>([]);
  var isLoading = false.obs;

  var currentPage = 1.obs;
  var limit = 10.obs;
  Future<void> fetchProfile() async {
    final userId = LocalStorageService.getUserId();
    try {
      final res = await BaseClient.get(api: "${EndPoint.fetchProfile}/$userId");

      if (res != null && res.statusCode == 200) {
        profileModel.value = profileModelFromJson(json.encode(res.data));
        LoggerUtils.debug(
          "Profile Model: ${json.encode(profileModel.value)}",
          tag: "ProfileController",
        );
      } else {
        LoggerUtils.debug(
          "Failed: ${json.encode(res?.data)}",
          tag: "ProfileController",
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      update();
    }
  }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    final profileId = LocalStorageService.getProfileId();
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.userProfile}/$profileId",
      );

      if (res != null && res.statusCode == 200) {
        userProfileModel.value = userProfileModelFromJson(
          json.encode(res.data),
        );
        LoggerUtils.debug(
          "User Profile Model: ${json.encode(profileModel.value)}",
          tag: "ProfileController",
        );
      } else {
        LoggerUtils.debug(
          "Failed: ${json.encode(res?.data)}",
          tag: "ProfileController",
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> fetchUserPost() async {
    isLoading.value = true;
    final userId = LocalStorageService.getUserId();
    final profileId = LocalStorageService.getProfileId();
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getMyPost}?userId=$userId&profileId=$profileId&postType=Post&pageNumber=${currentPage.value}&pageSize=${limit.value}",
      );

      if (res != null && res.statusCode == 200) {
        myPostModel.value = myPostModelFromJson(json.encode(res.data));

        myPostList.addAll(myPostModel.value?.myPostData ?? []);
        LoggerUtils.debug(
          "My Post Model: ${json.encode(profileModel.value)}",
          tag: "ProfileController",
        );
      } else {
        LoggerUtils.debug(
          "Failed: ${json.encode(res?.data)}",
          tag: "ProfileController",
        );
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> apiCallMyPost() async {
    myPostList.clear();
    await fetchUserPost();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((value) async {
      // await fetchProfile();
      await fetchUserProfile();
      await fetchUserPost();
      myPostScrollController.addListener(scroll);
    });

    super.onInit();
  }

  void scroll() async {
    final totalPage = myPostModel.value?.pagination?.totalPages;
    final scrollPostion =
        myPostScrollController.position.pixels >=
        myPostScrollController.position.maxScrollExtent - 200;
    if (scrollPostion && !isLoading.value && currentPage < (totalPage ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = myPostModel.value?.pagination?.totalPages ?? 0;
    final totalReacord = myPostModel.value?.pagination?.totalCount ?? 0;
    if (currentPage < lastPage &&
        !isLoading.value &&
        myPostList.length < totalReacord) {
      currentPage.value++;
      debugPrint("_currentPage $currentPage");
      fetchUserPost();
    }
  }

  final Rx<XFile?> profileImage = Rx<XFile?>(null);
  final Rx<XFile?> coverImage = Rx<XFile?>(null);

  Future<void> imageCoverUpload() async {
    final XFile? image = await SingleImagePickerDialog.show(
      Get.context!,
      IMGType.profilePicture,
    );

    if (image != null) {
      coverImage.value = image;
      await uploadImageCanva();
    }
  }

  Future<void> uploadImageCanva() async {
    try {
      final profileId = LocalStorageService.getProfileId();
      final formData = FormData.fromMap({
        'CoverImage': await MultipartFile.fromFile(
          coverImage.value?.path ?? "",
          filename: coverImage.value!.path.split('/').last,
        ),
        'ProfileID': profileId,
      });
      final res = await BaseClient.post(
        api: EndPoint.updateCoverImage,
        formData: formData,
      );

      if (res != null && res.statusCode == 201) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
        await Future.delayed(Duration(milliseconds: 100));
        await fetchUserProfile();
      } else {
        SnackBarUiView.showError(message: "Something went wrong");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    }
  }

   Future<void> imageProfileUpload() async {
    final XFile? image = await SingleImagePickerDialog.show(
      Get.context!,
      IMGType.profilePicture,
    );

    if (image != null) {
      profileImage.value = image;
      await uploadImagePicture();
    }
  }

  Future<void> uploadImagePicture() async {
    try {
      final profileId = LocalStorageService.getProfileId();
      final formData = FormData.fromMap({
        'ProfilePicture': await MultipartFile.fromFile(
          coverImage.value?.path ?? "",
          filename: profileImage.value!.path.split('/').last,
        ),
        'ProfileID': profileId,
      });
      final res = await BaseClient.post(
        api: EndPoint.editProfilePicture,
        formData: formData,
      );

      if (res != null && res.statusCode == 201) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
        await Future.delayed(Duration(milliseconds: 100));
        await fetchUserProfile();
      } else {
        SnackBarUiView.showError(message: "Something went wrong");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    }
  }
}
