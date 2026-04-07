import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Import from your media preview module:
// ─────────────────────────────────────────────────────────────────────────────
import 'package:social_book/app/modules/mediaPreview/controllers/media_preview_controller.dart';
import 'package:social_book/app/modules/story/controllers/story_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

// ─────────────────────────────────────────────────────────────────────────────
// PostUploadController
// ─────────────────────────────────────────────────────────────────────────────

class PostUploadController extends GetxController {
  // ── Dependencies ──────────────────────────────────────────
  RxList<File> files = RxList<File>([]);
  Rxn<FilterType> filter = Rxn<FilterType>(null);

  @override
  void onInit() {
    final map = Get.arguments;

    if (map != null) {
      files.value = List<File>.from(map["files"]);
      filter.value = map["filter"];
    }
    super.onInit();
  }

  // ── TextEditingController ─────────────────────────────────
  final captionController = TextEditingController();
  final locationController = TextEditingController();
  final tagController = TextEditingController();

  // ── Observables ───────────────────────────────────────────
  final RxInt currentPage = 0.obs;
  final RxBool isUploading = false.obs;
  final RxBool advancedExpanded = false.obs;
  final RxList<String> tags = <String>[].obs;

  // Audience options
  final RxString audience = 'Everyone'.obs;
  final List<String> audienceOptions = ['Everyone', 'Friends', 'Only me'];

  // Toggle options
  final RxBool allowComments = true.obs;
  final RxBool allowLikes = true.obs;
  final RxBool highQuality = true.obs;

  @override
  void onClose() {
    captionController.dispose();
    locationController.dispose();
    tagController.dispose();
    super.onClose();
  }

  // ── Add / remove tags ─────────────────────────────────────
  void addTag(String raw) {
    final tag = raw.trim().replaceAll('#', '');
    if (tag.isEmpty || tags.contains(tag) || tags.length >= 30) return;
    tags.add(tag);
    tagController.clear();
  }

  void removeTag(String tag) => tags.remove(tag);


/// ─────────────────────────────
  /// Upload Post API
  /// ─────────────────────────────
  /// 
    int? userId = LocalStorageService.getUserId();
  int? profileId = LocalStorageService.getProfileId();
RxString? latitude=RxString("78.980");
RxString? longitude=RxString("78.980");

Future<void> sharePost() async {

  final storyController = Get.find<StoryController>();
  if (files.isEmpty && captionController.text.trim().isEmpty) {
    SnackBarUiView.showWarning(
      message: "Please add media or caption",
      icon: Icons.warning,
    );
    return;
  }

  debugPrint("UserID: $userId");
  debugPrint("ProfileID: $profileId");
  debugPrint("Content: ${captionController.text.trim()}");
  debugPrint("PostType: Story");
  debugPrint("PrivacyLevel: ${audience.value}");
  debugPrint("Tags: ${tags.join(",")}");

  if (locationController.text.isNotEmpty) {
    debugPrint("Location: ${locationController.text}");
  }

  if (latitude?.value != null) {
    debugPrint("Latitude: ${latitude?.value}");
  }

  if (longitude?.value != null) {
    debugPrint("Longitude: ${longitude?.value}");
  }

  try {
    isUploading.value = true;

    final formData = FormData.fromMap({
      "UserID": userId.toString(),
      "ProfileID": profileId.toString(),
      "Content": captionController.text.trim(),
      "PostType": "Story",
      "PrivacyLevel": "Public",
      "Tags": "Kids",

      if (locationController.text.isNotEmpty)
        "Location": locationController.text,

      if (latitude?.value != null)
        "Latitude": latitude?.value.toString(),

      if (longitude?.value != null)
        "Longitude": longitude?.value.toString(),
    });

    /// Upload files
    for (int i = 0; i < files.length; i++) {
      final file = files[i];

      debugPrint("Uploading File ${i + 1}: ${file.path}");

      formData.files.add(
        MapEntry(
          "file${i + 1}",
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    /// Print all FormData fields
    debugPrint("------ FormData Fields ------");
    for (var field in formData.fields) {
      debugPrint("${field.key} : ${field.value}");
    }

    /// Print files
    debugPrint("------ Files ------");
    for (var file in formData.files) {
      debugPrint("${file.key} : ${file.value.filename}");
    }

    final response = await BaseClient.post(
      api: EndPoint.createMyPost,
      data: formData,
    );

    debugPrint("API Response: ${response?.statusCode}");
    debugPrint("Response Data: ${response?.data}");

    if (response != null && response.statusCode == 201) {
      SnackBarUiView.showSuccess(
        message: "Post created successfully!",
        icon: Icons.check_circle,
      );

      // Get.back(result: true);
      await storyController.fetchMyStory();
      await storyController.fetchStory();
      Get.offNamed(Routes.NAV);
    } else {
      throw Exception("Failed to create post");
    }
  } on DioException catch (e) {
    print("Dio Error: ${e.response?.data}");

    String error = "Failed to create post";

    if (e.response?.data is Map && e.response?.data["message"] != null) {
      error = e.response!.data["message"];
    }

    SnackBarUiView.showError(
      message: error,
      icon: Icons.error,
    );
  } catch (e) {
    print("Unexpected Error: $e");

    SnackBarUiView.showError(
      message: "Unexpected error occurred",
      icon: Icons.error,
    );
  } finally {
    isUploading.value = false;
  }
}
}
