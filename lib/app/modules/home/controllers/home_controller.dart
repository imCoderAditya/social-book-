import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart'
    show BaseClient;
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/services/common_services/like_service.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class HomeController extends GetxController {
  var selectIndex = 0.obs;
  var isLoading = false.obs;

  var currentPage = 1.obs;
  var limit = 20.obs;

  ScrollController postScrollController = ScrollController();
  Rxn<PostModel> postModel = Rxn<PostModel>();
  RxList<PostData> postList = RxList<PostData>();

  Future<void> fetchSocialPost() async {
    isLoading.value = true;
    final userId = LocalStorageService.getUserId();
    final profileId = LocalStorageService.getProfileId();
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.getPost}?userId=$userId&profileId=$profileId&search=&pageNumber=${currentPage.value}&pageSize=${limit.value}",
      );
      if (res != null && res.statusCode == 200) {
        postModel.value = postModelFromJson(json.encode(res.data));
        postList.addAll(postModel.value?.postData ?? []);
        LoggerUtils.debug("Post: ${json.encode(postModel.value)}");
      } else {
        LoggerUtils.debug("Post Failed ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onInit() {
    fetchSocialPost();
    postScrollController.addListener(scroll);
    super.onInit();
  }

  Future<void> scroll() async {
    debugPrint(currentPage.toString());
    final totalPage = postModel.value?.pagination?.totalPages;
    if (postScrollController.position.pixels >=
            postScrollController.position.maxScrollExtent - 200 &&
        !isLoading.value &&
        currentPage < (totalPage ?? 0)) {
      loadMoreTransaction();
    }
  }

  void loadMoreTransaction() {
    final lastPage = postModel.value?.pagination?.totalPages ?? 0;
    final totalRecords = postModel.value?.pagination?.totalCount ?? 0;
    if (currentPage < lastPage &&
        !isLoading.value &&
        postList.length < totalRecords) {
      currentPage.value++;
      debugPrint("_currentPage $currentPage");
      fetchSocialPost();
      update();
    }
  }

  void toggleLike(int index) async {
    final oldPost = postList[index];

    final bool isLiked = oldPost.myReactionType == "Like";

    final updatedPost = oldPost.copyWith(
      myReactionType: isLiked ? "NoReaction" : "Like",
      totalLikes: (oldPost.totalLikes ?? 0) + (isLiked ? -1 : 1),
    );

    // 🔁 Replace item in list (VERY IMPORTANT)
    postList[index] = updatedPost;
    update();
    // 🔽 API call background me
    // likeUnlikeApi(updatedPost.postId, updatedPost.myReactionType);
    final bool success = await LikeService.to.like(
      contentId: oldPost.postId!,
      isCurrentlyLiked: isLiked,
    );
    if (success) {
      SnackBarUiView.showInfo(message: "Like Successfully");
    } else {
      postList[index] = oldPost; // Purana backup wapas set kiya
      update();
      SnackBarUiView.showInfo(message: "Failed to update like");
    }
  }

  @override
  void dispose() {
    // feedScrollController.dispose();
    postScrollController.dispose();
    super.dispose();
  }
}
