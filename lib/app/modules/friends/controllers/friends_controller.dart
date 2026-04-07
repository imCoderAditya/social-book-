import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/friends/friend_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class FriendsController extends GetxController {
  Rxn<FriendModel> friendModel = Rxn<FriendModel>();
  RxList friendList = [].obs;
  ScrollController scrollController = ScrollController();
  var curentPage = 1.obs;
  var pageSize = 20; // fetch 20 friends per page
  var isLoading = false.obs;
  var noMoreData = false.obs;

  Future<void> fetchFriends() async {
    final userId = LocalStorageService.getUserId();
    final profileId = (LocalStorageService.getProfileId())!;
    log("Profile Id ==>: $profileId");
    update();
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getFriends}?userId=$userId&profileId=$profileId&type=Friend&pageNumber=$curentPage&pageSize=$pageSize",
      );
      if (res != null && res.statusCode == 200) {
        friendModel.value = friendModelFromJson(json.encode(res.data));
        LoggerUtils.debug(
          "Firiend: ${json.encode(res.data)}",
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

  @override
  void onInit() {
    fetchFriends();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void _onScroll() {
    debugPrint("_currentPage $curentPage");
    debugPrint(curentPage.toString());

    final totalPages =
        friendModel.value?.pagination?.totalPages; // get total pages
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 && // added buffer
        !isLoading.value &&
        curentPage < (totalPages ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = friendModel.value?.pagination?.totalPages ?? 0;
    final totalRecords = friendModel.value?.pagination?.totalRecords ?? 0;

    if (!isLoading.value &&
        curentPage.value < lastPage &&
        friendList.length < totalRecords) {
      curentPage.value++;
      fetchFriends(); // This handles loading and update itself
    }
  }
}
