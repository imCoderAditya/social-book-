import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/post/my_post_model.dart';
import 'package:social_book/app/data/models/profile/profile_model.dart';
import 'package:social_book/app/data/models/profile/user_profile_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class ProfileOtherUserController extends GetxController {
  ScrollController myPostScrollController = ScrollController();
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Rxn<UserProfileModel> otherUserProfileModel = Rxn<UserProfileModel>();
  Rxn<MyPostModel> myPostModel = Rxn<MyPostModel>();
  RxList<MyPostData> myPostList = RxList<MyPostData>([]);
  var isLoading = false.obs;

  var currentPage = 1.obs;
  var limit = 10.obs;

  RxInt userProfileId = RxInt(0);
  // Future<void> fetchProfile() async {

  //   try {
  //     final res = await BaseClient.get(api: "${EndPoint.fetchProfileOtherUser}/${userProfileId.value}");

  //     if (res != null && res.statusCode == 200) {
  //       profileModel.value = profileModelFromJson(json.encode(res.data));
  //       LoggerUtils.debug(
  //         "Profile Model: ${json.encode(profileModel.value)}",
  //         tag: "ProfileOtherUserController",
  //       );
  //     } else {
  //       LoggerUtils.debug(
  //         "Failed: ${json.encode(res?.data)}",
  //         tag: "ProfileOtherUserController",
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint("Error: $e");
  //   } finally {
  //     update();
  //   }
  // }

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.fetchProfileOtherUser}/${userProfileId.value}",
      );

      if (res != null && res.statusCode == 200) {
        otherUserProfileModel.value = userProfileModelFromJson(
          json.encode(res.data),
        );
        LoggerUtils.debug(
          "User Profile Model: ${json.encode(otherUserProfileModel.value)}",
          tag: "ProfileOtherUserController",
        );
      } else {
        LoggerUtils.debug(
          "Failed: ${json.encode(res?.data)}",
          tag: "ProfileOtherUserController",
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
        // myPostModel.value = myPostModelFromJson(json.encode(res.data));

        // myPostList.addAll(myPostModel.value?.myPostData ?? []);
        // LoggerUtils.debug(
        //   "My Post Model: ${json.encode(myPostModel.value)}",
        //   tag: "ProfileController",
        // );
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
      userProfileId.value = Get.arguments["profileId"];
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
}
