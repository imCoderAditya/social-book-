// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/core/utils/media_picker.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/data/models/reels/reel_comments_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class CommentController extends GetxController {
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final isLoading = false.obs;
  Rxn<ReelCommentModel> postCommentModel = Rxn<ReelCommentModel>();
  final userId = LocalStorageService.getUserId();
  final profileId = LocalStorageService.getProfileId();

  RxInt totalComment = RxInt(0);

  Future<bool> createComments({
    int? postId,
    int? parentCommentId,
    XFile? mediaFile,
  }) async {
    isLoading.value = true;

    try {
      final dataMap = {
        "UserID": userId.toString(),
        "ProfileID": profileId.toString(),
        "PostID": postId.toString(),
        "CommentText": commentController.text,
        "ParentCommentID": parentCommentId?.toString(),
      };
       print(dataMap);
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
        commentController.clear();
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

  Future<void> fetchComments({int? postId, int? profileId}) async {
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.postWithComments}?postId=$postId&profileId=$profileId",
      );
      if (res != null && res.statusCode == 200) {
        postCommentModel.value = reelCommentModelFromJson(
          json.encode(res.data),
        );
        totalComment.value =
            postCommentModel.value?.data?.comments?.length ?? 0;
      } else {
        LoggerUtils.error("Failed: ${res?.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      update();
    }
  }

  Future<void> uploadImage({int? postId}) async {
    final result = await MediaPickerUtil.pickMedia(
      source: ImageSource.gallery,
      pickImage: true,
    );

    if (result != null && result.isImage) {
      log("Image path => ${result.file.path}");

      await createComments(postId: postId, mediaFile: result.file);
    }
  }

  Future<void> deleteComment({int? commentID,PostData? postData}) async {
    try {
      final _userId = int.tryParse(userId.toString());
      final _profileId = int.tryParse(profileId.toString());
      final res = await BaseClient.post(
        api: EndPoint.commentDelete,
        data: {
          "CommentID": commentID,
          "UserID": _userId,
          "ProfileID": _profileId,
        },
      );
      if (res != null && res.statusCode == 201) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
        await fetchComments(
          postId: postData?.postId,
          profileId: profileId,
        );
      } else {
        LoggerUtils.debug("Reponse : ${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    }finally{
      update();
    }
  }

  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }


  // Controller ke andar ye variables add karein
Rxn<Comment> replyingToComment = Rxn<Comment>(); // Reply track karne ke liye

void setReply(Comment comment) {
  replyingToComment.value = comment;
  focusNode.requestFocus(); // Keyboard open ho jayega
}

void cancelReply() {
  replyingToComment.value = null;
  commentController.clear();
}
}
