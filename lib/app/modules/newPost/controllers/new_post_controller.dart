import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class NewPostController extends GetxController {
  final profileController = Get.find<ProfileController>();
  // Text Controllers
  final TextEditingController contentController = TextEditingController();

  // Observable Variables
  final RxList<XFile> selectedFiles = <XFile>[].obs;
  final RxString privacyLevel = 'Public'.obs;
  final RxString cameraStatus = 'Off'.obs;
  final RxBool isPosting = false.obs;
  final RxString postType = 'Text'.obs;
  final RxString location = ''.obs;
  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  final RxString music = ''.obs;
  final RxString feeling = ''.obs;
  final RxList<String> taggedPeople = <String>[].obs;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  int? userId = LocalStorageService.getUserId();
  int? profileId = LocalStorageService.getProfileId();


  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  // Pick Multiple Images/Videos
  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedFiles.addAll(images);
        _updatePostType();
        SnackBarUiView.showSuccess(
          message: '${images.length} file(s) selected',
          icon: Icons.check_circle,
        );
      }
    } catch (e) {
      SnackBarUiView.showError(message: 'Error picking images: $e');
    }
  }

  // Pick Video
  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        selectedFiles.add(video);
        _updatePostType();
        SnackBarUiView.showSuccess(
          message: 'Video selected',
          icon: Icons.videocam,
        );
      }
    } catch (e) {
      SnackBarUiView.showError(message: 'Error picking video: $e');
    }
  }

  // Remove File
  void removeFile(int index) {
    selectedFiles.removeAt(index);
    _updatePostType();
  }

  // Update Post Type based on selected files
  void _updatePostType() {
    if (selectedFiles.isEmpty) {
      postType.value = 'Text';
    } else {
      // final hasVideo = selectedFiles.any(
      //   (file) =>
      //       file.path.toLowerCase().endsWith('.mp4') ||
      //       file.path.toLowerCase().endsWith('.mov') ||
      //       file.path.toLowerCase().endsWith('.avi'),
      // );
      const videoExtensions = [
        '.mp4',
        '.mov',
        '.avi',
        '.mkv',
        '.flv',
        '.wmv',
        '.webm',
        '.3gp',
        '.mpeg',
        '.mpg',
        '.m4v',
      ];

      final hasVideo = selectedFiles.any((file) {
        final path = file.path.toLowerCase();
        return videoExtensions.any(path.endsWith);
      });

      postType.value = hasVideo ? 'Video' : 'Image';
    }
  }

  // Toggle Privacy
  void togglePrivacy() {
    final privacyOptions = ['Public', 'Friends', 'Private'];
    final currentIndex = privacyOptions.indexOf(privacyLevel.value);
    final nextIndex = (currentIndex + 1) % privacyOptions.length;
    privacyLevel.value = privacyOptions[nextIndex];
  }

  // Toggle Camera
  void toggleCamera() {
    cameraStatus.value = cameraStatus.value == 'Off' ? 'On' : 'Off';
  }

  // Action Button Callbacks
  void onMusicTap() {
    SnackBarUiView.showInfo(
      message: 'Music selection coming soon!',
      icon: Icons.music_note,
    );
  }

  void onPeopleTap() {
    SnackBarUiView.showInfo(
      message: 'Tag people coming soon!',
      icon: Icons.people,
    );
  }

  void onLocationTap() {
    SnackBarUiView.showInfo(
      message: 'Location selection coming soon!',
      icon: Icons.location_on,
    );
    // Here you can implement location picker
    // For now, using default Mumbai location
    location.value = 'Mumbai';
    latitude.value = '19.0760';
    longitude.value = '72.8777';
  }

  void onFeelingTap() {
    SnackBarUiView.showInfo(
      message: 'Feeling/Activity selection coming soon!',
      icon: Icons.emoji_emotions,
    );
  }

Future<void> createPost() async {
  if (contentController.text.trim().isEmpty && selectedFiles.isEmpty) {
    SnackBarUiView.showWarning(
      message: 'Please add some content or media',
      icon: Icons.warning,
    );
    return;
  }

  try {
    isPosting.value = true;

    final formData = FormData.fromMap({
      'UserID': userId.toString(),
      'ProfileID': profileId.toString(),
      'Content': contentController.text.trim(),
      'PostType': "Story",
      'PrivacyLevel': privacyLevel.value,
      'Tags': "", // optional
    });

    /// Location
    if (location.value.isNotEmpty) {
      formData.fields.addAll([
        MapEntry('Location', location.value),
        MapEntry('Latitude', latitude.value.toString()),
        MapEntry('Longitude', longitude.value.toString()),
      ]);
    }

    /// Files upload
    for (int i = 0; i < selectedFiles.length; i++) {
      final file = selectedFiles[i];

      formData.files.add(
        MapEntry(
          'file${i + 1}',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    final response = await BaseClient.post(
      api: EndPoint.createMyPost,
      data: formData,
    );

    if (response != null && response.statusCode == 201) {
      await profileController.apiCallMyPost();

      SnackBarUiView.showSuccess(
        message: 'Post created successfully!',
        icon: Icons.check_circle,
      );

      contentController.clear();
      selectedFiles.clear();
      privacyLevel.value = 'Public';
      location.value = '';

      Get.back(result: true);
    } else {
      throw Exception('Failed to create post');
    }
  }  catch (e) {
    SnackBarUiView.showError(
      message: 'Unexpected error occurred',
      icon: Icons.error,
    );
    debugPrint('createPost error: $e');
  } finally {
    isPosting.value = false;
  }
}
}
