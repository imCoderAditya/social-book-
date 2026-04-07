import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:social_book/app/components/snack_bar_view.dart';

import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/enums/friend_status_ext.dart';
import 'package:social_book/app/data/enums/riend_status.dart';
import 'package:social_book/app/data/models/friends/add_friend_model.dart';
import 'package:social_book/app/data/models/friends/friend_request_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class AddFriendsController extends GetxController {
  final Rx<FriendStatus> status = FriendStatus.friend.obs;

  /// UI se set
  void setStatus(FriendStatus value) {
    status.value = value;
  }

  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  final selectedTab = 0.obs;
  final isLoading = false.obs;

  final friendRequests = <Map<String, dynamic>>[].obs;
  // saggestion
  Rxn<AddFriendsModel> addFriendsModel = Rxn<AddFriendsModel>();
  RxList<AddFriends> addFriendsList = RxList<AddFriends>();
  // Friends Request
  Rxn<FriendRequestModel> friendRequestModel = Rxn<FriendRequestModel>();
  RxList<FriendRequest> friendRequestList = RxList<FriendRequest>();
  // Send Request
  Rxn<FriendRequestModel> sendFriendRequestModel = Rxn<FriendRequestModel>();
  RxList<FriendRequest> sendFriendRequestList = RxList<FriendRequest>();
  // final userController = Get.find<UserController>();
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await fetchAddFriendData();
      await fetchFriendRequestData();
      await fetchSendFriendRequestData();
    });

    scrollController.addListener(_scroll);
  }

  RxInt currentPage = 1.obs;
  RxInt totalItem = 10.obs;

  Future<void> fetchAddFriendData({String? query = ""}) async {
    // for saggestion Api data
    // final userId = LocalStorageService.getSocialProfileId();
    final profileId = LocalStorageService.getProfileId();
    isLoading.value = true;

    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.userAddFriendSearch}?profileId=$profileId&search=${query?.trim()}&pageNumber=${currentPage.value}&pageSize=${totalItem.value}",
      );

      if (res != null && res.statusCode == 200) {
        addFriendsModel.value = addFriendsModelFromJson(json.encode(res.data));

        final newList = addFriendsModel.value?.addFriends ?? [];
        // 🔥 Prevent duplicate entries in list
        addFriendsList.addAll(
          newList.where(
            (friend) =>
                !addFriendsList.any(
                  (oldItem) => oldItem.profileId == friend.profileId,
                ),
          ),
        );
        LoggerUtils.debug(
          "Updated Friends Count: ${json.encode(addFriendsList)}",
        );
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  _scroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreAddFriends();
    }
  }

  void loadMoreAddFriends() {
    final pagination = addFriendsModel.value?.pagination;
    final totalPage = pagination?.totalPages ?? 0;
    final totalCount = pagination?.totalCount ?? 0;

    final newToalRecord = currentPage < totalPage;
    final totalRecord = addFriendsList.length < totalCount;
    if (newToalRecord && !isLoading.value && totalRecord) {
      currentPage.value++;
      fetchAddFriendData();
      update();
    }
  }

  RxInt currentFriendRequestPage = 1.obs;
  RxInt friendRequestTotalItem = 10.obs;

  Future<void> fetchFriendRequestData({String? query = ""}) async {
    final profileId = LocalStorageService.getProfileId();
    final userId = LocalStorageService.getUserId();
    isLoading.value = true;

    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getFriendRequest}?userId=$userId&profileId=$profileId&type=Received&search=${query?.trim()}&pageNumber=${currentFriendRequestPage.value}&pageSize=${friendRequestTotalItem.value}",
      );

      if (res != null && res.statusCode == 200) {
        friendRequestModel.value = friendRequestModelFromJson(
          json.encode(res.data),
        );

        final newList = friendRequestModel.value?.friendRequest ?? [];
        // 🔥 Prevent duplicate entries in list
        friendRequestList.addAll(
          newList.where(
            (friend) =>
                !friendRequestList.any(
                  (oldItem) => oldItem.friendId == friend.friendId,
                ),
          ),
        );
        debugPrint("Friends Request: ${json.encode(friendRequestList)}");
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  RxInt currentSendFriendRequestPage = 1.obs;
  RxInt sendFriendRequestTotalItem = 10.obs;

  Future<void> fetchSendFriendRequestData({String? query = ""}) async {
    final profileId = LocalStorageService.getProfileId();
    final userId = LocalStorageService.getUserId();
    isLoading.value = true;

    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getFriendRequest}?userId=$userId&profileId=$profileId&type=Sent&search=${query?.trim()}&pageNumber=${currentSendFriendRequestPage.value}&pageSize=${sendFriendRequestTotalItem.value}",
      );

      if (res != null && res.statusCode == 200) {
        sendFriendRequestModel.value = friendRequestModelFromJson(
          json.encode(res.data),
        );

        final newList = sendFriendRequestModel.value?.friendRequest ?? [];
        // 🔥 Prevent duplicate entries in list
        sendFriendRequestList.addAll(
          newList.where(
            (friend) =>
                !sendFriendRequestList.any(
                  (oldItem) => oldItem.friendId == friend.friendId,
                ),
          ),
        );
        debugPrint(
          "Send Friends Request: ${json.encode(sendFriendRequestList)}",
        );
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> searchFriends(String query) async {
    if (selectedTab.value == 0) {
      if (query.isEmpty) {
        fetchAddFriendData();
      }
      if (query.length > 3) {
        currentPage.value = 1;
        addFriendsList.clear();
        fetchAddFriendData(query: query);
      }
    } else if (selectedTab.value == 1) {
      if (query.isEmpty) {
        fetchFriendRequestData();
      }
      if (query.length > 3) {
        currentFriendRequestPage.value = 1;
        friendRequestList.clear();
        fetchFriendRequestData(query: query);
      }
    } else {
      if (query.isEmpty) {
        fetchSendFriendRequestData();
      }
      if (query.length > 3) {
        currentSendFriendRequestPage.value = 1;
        sendFriendRequestList.clear();
        fetchSendFriendRequestData(query: query);
      }
    }
  }

  final profileId = LocalStorageService.getProfileId();
  final userId = LocalStorageService.getUserId();

  Future<void> sendFriendRequest({
    int? receiverUserID,
    int? receiverProfileID,
    required int index,
  }) async {
    // addFriendsList[index].sendRequestLoader == true;
    addFriendsList[index] = addFriendsList[index].copyWith(
      sendRequestLoader: true,
    );
    update();
    try {
      final res = await BaseClient.post(
        api: EndPoint.sendRequest,
        data: {
          "SenderUserID": userId,
          "SenderProfileID": profileId,
          "ReceiverUserID": receiverUserID,
          "ReceiverProfileID": receiverProfileID,
          "ConnectionType": "Friend",
        },
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
        SnackBarUiView.showInfo(message: res.data["message"]);
        addFriendsList[index] = addFriendsList[index].copyWith(
          isSendRequest: true,
        );
      } else {
        // SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.error("error:$e");
    } finally {
      addFriendsList[index] = addFriendsList[index].copyWith(
        sendRequestLoader: false,
      );
      update();
    }
  }

  void acceptRejectFriendRequest({
    int? friendID,
    required int index,
    String? type,
  }) async {
    try {
      friendRequestList[index] = friendRequestList[index].copyWith(
        confirmRequestLoader: false,
      );
      final res = await BaseClient.post(
        api: EndPoint.espondToRequest,
        data: {
          "FriendID": friendID,
          "ReceiverUserID": userId,
          "ReceiverProfileID": profileId,
          "Action": status.value.apiValue,
        },
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
        SnackBarUiView.showInfo(message: res.data["message"]);

        if (type == "cancelRequest") {
          friendRequestList[index] = friendRequestList[index].copyWith(
            cancelRequest: true,
          );
        } else {
          friendRequestList[index] = friendRequestList[index].copyWith(
            confirmRequestLoader: true,
          );
        }
      } else {
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.error("error:$e");
    } finally {
      update();
    }
  }

  void rejectFriendRequest({int? friendID, String? type}) async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.rejectFriendRequestBySender,
        data: {
          "FriendID": friendID,
          "SenderProfileID": profileId,
          "Action": "Rejected",
        },
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
        SnackBarUiView.showInfo(message: res.data["message"]);
        sendFriendRequestList.clear();
        await fetchSendFriendRequestData();
      } else {
        LoggerUtils.debug("Response : ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.error("error:$e");
    } finally {
      update();
    }
  }

  // void removeSuggestion(String userId) {
  //   // suggestions.removeWhere((friend) => friend['id'] == userId);
  // }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
