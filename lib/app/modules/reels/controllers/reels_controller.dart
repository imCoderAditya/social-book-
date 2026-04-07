import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';

import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/reels/reel_comments_model.dart';
import 'package:social_book/app/data/models/reels/reels_model.dart';
import 'package:social_book/app/services/common_services/like_service.dart'
    show LikeService;
import 'package:social_book/app/services/storage/local_storage_service.dart';
import 'package:video_player/video_player.dart';

class ReelsController extends GetxController {
  Rxn<ReelCommentModel> reelCommentModel = Rxn<ReelCommentModel>();
  RxInt totalComment = RxInt(0);

  Rxn<ReelModel> reelModel = Rxn<ReelModel>();
  RxList<ReelData> reelList = RxList<ReelData>();
  final PageController pageController = PageController();
  VideoPlayerController? videoController;
  final currentIndex = 0.obs;
  final reels = <ReelModel>[].obs;
  final isLoading = false.obs;
  final isLikeDoubletab = false.obs;
  // For pagination Variable
  var currentPage = 1.obs;
  var limit = 10.obs;

  void setController(VideoPlayerController controller) {
    videoController = controller;
  }

  void pauseVideo() {
    videoController?.pause();
    log('Video pause');
  }

  void playVideo() {
    videoController?.play();
    log('Video Play');
  }

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  final userId = LocalStorageService.getUserId();
  final profileId = LocalStorageService.getProfileId();
  Future<void> fetchReels() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api:
            "${EndPoint.reels}?userId=$userId&profileId=$profileId&search=&PostType=Reel&pageNumber=${currentPage.value}&pageSize=${limit.value}",
      );

      if (res != null && res.statusCode == 200) {
        reelModel.value = reelModelFromJson(json.encode(res.data));
        final newList = reelModel.value?.reel ?? [];
        // 🔥 Prevent duplicate entries in list
        reelList.addAll(newList);

        await fetchComments(
          postId: reelList.firstOrNull?.postId,
          profileId: profileId,
        );

        log("Reels List ${json.encode(reelList)}");
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  void likeDoubleTap(int index) async {
    playHeartAnimation();
    final reel = reelList[index];
    final isAlreadyLiked = reel.isLiked ?? false;

    // ❤️ Show heart animation always
    isLikeDoubletab.value = true;

    // ❤️ If already liked → ONLY animation (NO API, NO dislike)
    if (isAlreadyLiked) {
      await Future.delayed(const Duration(milliseconds: 800));
      isLikeDoubletab.value = false;
      return;
    }

    // ❤️ Force LIKE (never toggle)
    reelList[index] = reel.copyWith(
      isLiked: true,
      totalLikes: (reel.totalLikes ?? 0) + 1,
      myReactionType: "Like",
    );
    reelList.refresh();

    try {
      // await like(
      //   postId: reel.postId,
      //   isLike: true, // 🔥 ALWAYS TRUE
      // );
      await LikeService.to.like(
        contentId: reel.postId ?? 0,
        isCurrentlyLiked: true,
      );
    } catch (e) {
      // rollback if needed
      reelList[index] = reel;
      reelList.refresh();
    }

    await Future.delayed(const Duration(milliseconds: 800));
    isLikeDoubletab.value = false;
  }

  Future<void> toggleLike(int index) async {
    final oldReel = reelList[index];

    final wasLiked = oldReel.isLiked ?? false;
    final currentLikes = oldReel.totalLikes ?? 0;

    // 🔥 NEW STATE
    final newIsLiked = !wasLiked;

    // 1️⃣ Optimistic UI update
    reelList[index] = oldReel.copyWith(
      isLiked: newIsLiked,
      totalLikes: currentLikes + (newIsLiked ? 1 : -1),
      myReactionType: newIsLiked ? "Like" : "unLike",
    );
    reelList.refresh();

    try {
      // 2️⃣ API call with NEW STATE
      // await like(postId: oldReel.postId, isLike: newIsLiked);
      await LikeService.to.like(
        contentId: oldReel.postId!,
        isCurrentlyLiked: newIsLiked,
      );
    } catch (e) {
      // 3️⃣ Rollback
      reelList[index] = oldReel;
      reelList.refresh();
    }
  }

  // Future<void> like({int? postId, bool? isLike}) async {
  //   // widget.reel?.isLiked ?? false ||
  //   try {
  //     final res = await BaseClient.post(
  //       api: EndPoint.like,
  //       data: {
  //         "ContentType": "Post",
  //         "ContentID": postId,
  //         "ProfileID": profileId,
  //         "ReactionType": isLike == true ? "Like" : "unLike",
  //       },
  //     );
  //     if (res != null && res.statusCode == 200) {
  //       LoggerUtils.debug("Like Response ${res.data}");
  //     } else {
  //       LoggerUtils.error("Failed ${res?.data}");
  //     }
  //   } catch (e) {
  //     LoggerUtils.error("Error $e");
  //   }
  // }

  void onPageChanged(index) async {
    totalComment.value = 0;
    currentIndex.value = index;


    final totalPage = reelModel.value?.pagination?.totalPages ?? 0;

    // 🔥 Last reel reached → load more
    if (index == reelList.length - 3 &&
        !isLoading.value &&
        currentPage.value < totalPage) {
      loadMoreReels();
    }
    final profileId = LocalStorageService.getProfileId();

    await fetchComments(postId: reelList[index].postId, profileId: profileId);
  }

  Future<void> loadMoreReels() async {
    if (isLoading.value) return;

    final lastPage = reelModel.value?.pagination?.totalPages ?? 0;

    if (currentPage.value >= lastPage) return;

    isLoading.value = true;
    currentPage.value++;

    debugPrint("Loading page ${currentPage.value}");

    await fetchReels(); // API call

    isLoading.value = false;
  }

  Future<void> fetchComments({int? postId, int? profileId}) async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.postWithComments}?postId=$postId&profileId=$profileId",
      );
      if (res != null && res.statusCode == 200) {
        reelCommentModel.value = reelCommentModelFromJson(
          json.encode(res.data),
        );
        totalComment.value =
            reelCommentModel.value?.data?.comments?.length ?? 0;
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }

  Future<bool> createComments({
    String? commentText,
    int? postId,
    int? parentCommentId,
    XFile? mediaFile,
  }) async {
    isLoading.value = true;

    try {
      final dataMap = {
        "UserID": userId.toString(), // 27
        "ProfileID": profileId.toString(), // 15
        "PostID": postId.toString(), // 101
        "CommentText": commentText, // "This is a test comment"
        "ParentCommentID": parentCommentId?.toString(), // optional
      };
      final formData = FormData.fromMap(dataMap);
      if (mediaFile != null) {
        formData.files.add(
          MapEntry('MediaFile', await MultipartFile.fromFile(mediaFile.path)),
        );
      }
      final res = await BaseClient.post(
        api: EndPoint.commentsCreate,
        formData: formData,
      );
      if (res != null && res.statusCode == 201) {
        await fetchComments(postId: postId, profileId: profileId);
        return true;
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
        return false;
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }

  // ❤️ Animation values
  RxDouble heartScale = 0.0.obs;
  RxDouble heartOpacity = 0.0.obs;

  void playHeartAnimation() {
    isLikeDoubletab.value = true;
    heartScale.value = 1.3;
    heartOpacity.value = 1.0;

    // 💥 Bounce back
    Future.delayed(const Duration(milliseconds: 200), () {
      heartScale.value = 1.0;
    });

    // 🌫 Fade out
    Future.delayed(const Duration(milliseconds: 700), () {
      heartOpacity.value = 0.0;
    });

    // ❌ Hide completely
    Future.delayed(const Duration(milliseconds: 900), () {
      isLikeDoubletab.value = false;
    });
  }
}
