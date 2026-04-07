import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum IMGType { profilePicture, coverPhoto, story, post }

enum IMGSourceType { camera, gallery }

// =============================================================================
// SINGLE IMAGE PICKER DIALOG
// =============================================================================
class SingleImagePickerDialog extends StatelessWidget {
  final IMGType imageType;

  const SingleImagePickerDialog({super.key, required this.imageType});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () async {
                    Navigator.of(context).pop(); // Close dialog first
                    final imageFile = await ImagePickerHelper.pickSingleImage(
                      IMGSourceType.camera,
                    );
                    if (imageFile != null) {
                      Get.back(result: imageFile); // Return result
                    }
                  },
                  isDark: isDark,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () async {
                    final imageFile = await ImagePickerHelper.pickSingleImage(
                      IMGSourceType.gallery,
                    );
                    if (imageFile != null) {
                      log("imageFile $imageFile");
                      Get.back(result: imageFile); // Return result
                    }
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : const Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF677CE8)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog and return single image
  static Future<XFile?> show(BuildContext context, IMGType imageType) async {
    final XFile? result = await Get.dialog<XFile>(
      SingleImagePickerDialog(imageType: imageType),
      barrierDismissible: true,
    );
    return result;
  }
}

// =============================================================================
// MULTIPLE IMAGES PICKER DIALOG
// =============================================================================
class MultipleImagesPickerDialog extends StatelessWidget {
  final int maxImages;

  const MultipleImagesPickerDialog({super.key, this.maxImages = 10});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Multiple Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Max $maxImages images',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey : const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),
            _buildOption(
              context: context,
              icon: Icons.photo_library,
              label: 'Choose from Gallery',
              onTap: () async {
                Navigator.of(context).pop();
                final images = await ImagePickerHelper.pickMultipleImages(
                  maxImages: maxImages,
                );
                if (images.isNotEmpty) {
                  Get.back(result: images);
                }
              },
              isDark: isDark,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : const Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF677CE8)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog and return multiple images
  static Future<List<XFile>?> show(
    BuildContext context, {
    int maxImages = 10,
  }) async {
    final List<XFile>? result = await Get.dialog<List<XFile>>(
      MultipleImagesPickerDialog(maxImages: maxImages),
      barrierDismissible: true,
    );
    return result;
  }
}

// =============================================================================
// VIDEO PICKER DIALOG
// =============================================================================
class VideoPickerDialog extends StatelessWidget {
  final Duration maxDuration;

  const VideoPickerDialog({
    super.key,
    this.maxDuration = const Duration(seconds: 60),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Video Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Max ${maxDuration.inSeconds}s duration',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey : const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.videocam,
                  label: 'Record',
                  onTap: () async {
                    Navigator.of(context).pop();
                    final video = await ImagePickerHelper.pickVideo(
                      IMGSourceType.camera,
                      maxDuration: maxDuration,
                    );
                    if (video != null) {
                      Get.back(result: video);
                    }
                  },
                  isDark: isDark,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.video_library,
                  label: 'Gallery',
                  onTap: () async {
                    Navigator.of(context).pop();
                    final video = await ImagePickerHelper.pickVideo(
                      IMGSourceType.gallery,
                      maxDuration: maxDuration,
                    );
                    if (video != null) {
                      Get.back(result: video);
                    }
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : const Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: const Color(0xFF677CE8)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show dialog and return video
  static Future<XFile?> show(
    BuildContext context, {
    Duration maxDuration = const Duration(seconds: 60),
  }) async {
    final XFile? result = await Get.dialog<XFile>(
      VideoPickerDialog(maxDuration: maxDuration),
      barrierDismissible: true,
    );
    return result;
  }
}

// =============================================================================
// IMAGE PICKER HELPER
// =============================================================================
class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  /// Pick single image
  static Future<XFile?> pickSingleImage(IMGSourceType sourceType) async {
    try {
      // final hasPermission = await _requestPermission(sourceType);
      // if (!hasPermission) {
      //   _showPermissionDeniedDialog();
      //   return null;
      // }

      final XFile? pickedFile = await _picker.pickImage(
        source:
            sourceType == IMGSourceType.camera
                ? ImageSource.camera
                : ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        debugPrint('✅ Single image picked: ${pickedFile.path}');
      }
      return pickedFile;
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      _showError('Failed to pick image: $e');
      return null;
    }
  }

  /// Pick multiple images
  static Future<List<XFile>> pickMultipleImages({int maxImages = 10}) async {
    try {
      final hasPermission = await _requestPermission(IMGSourceType.gallery);
      if (!hasPermission) {
        _showPermissionDeniedDialog();
        return [];
      }

      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final limitedFiles = pickedFiles.take(maxImages).toList();
        debugPrint('✅ ${limitedFiles.length} images picked');
        return limitedFiles;
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error picking multiple images: $e');
      _showError('Failed to pick images: $e');
      return [];
    }
  }

  /// Pick video
  static Future<XFile?> pickVideo(
    IMGSourceType sourceType, {
    Duration maxDuration = const Duration(seconds: 60),
  }) async {
    try {
      final hasPermission = await _requestPermission(sourceType);
      if (!hasPermission) {
        _showPermissionDeniedDialog();
        return null;
      }

      final XFile? pickedFile = await _picker.pickVideo(
        source:
            sourceType == IMGSourceType.camera
                ? ImageSource.camera
                : ImageSource.gallery,
        maxDuration: maxDuration,
      );

      if (pickedFile != null) {
        debugPrint('✅ Video picked: ${pickedFile.path}');
      }
      return pickedFile;
    } catch (e) {
      debugPrint('❌ Error picking video: $e');
      _showError('Failed to pick video: $e');
      return null;
    }
  }

  /// Request permission
  static Future<bool> _requestPermission(IMGSourceType sourceType) async {
    if (sourceType == IMGSourceType.camera) {
      final status = await Permission.camera.request();
      return status.isGranted;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          final storageStatus = await Permission.storage.request();
          return storageStatus.isGranted;
        }
        return status.isGranted;
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        return status.isGranted;
      }
      return true;
    }
  }

  /// Show permission denied dialog
  static void _showPermissionDeniedDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Please grant the required permission from app settings.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show error
  static void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      duration: const Duration(seconds: 3),
    );
  }

  /// Validate file size
  static Future<bool> validateFileSize(
    XFile file, {
    double maxSizeMB = 10,
  }) async {
    final bytes = await file.length();
    final sizeMB = bytes / (1024 * 1024);

    if (sizeMB > maxSizeMB) {
      Get.snackbar(
        'Error',
        'File size (${sizeMB.toStringAsFixed(2)}MB) exceeds limit (${maxSizeMB}MB)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
    return true;
  }

  /// Get file size in MB
  static Future<double> getFileSizeInMB(XFile file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Check if file is image
  static bool isImageFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Check if file is video
  static bool isVideoFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension);
  }
}

// =============================================================================
// EXAMPLE CONTROLLER
// =============================================================================
class MediaPickerController extends GetxController {
  // Single images
  final Rx<XFile?> profileImage = Rx<XFile?>(null);
  final Rx<XFile?> coverImage = Rx<XFile?>(null);

  // Multiple images
  final RxList<XFile> postImages = <XFile>[].obs;
  final RxList<XFile> galleryImages = <XFile>[].obs;

  // Videos
  final Rx<XFile?> storyVideo = Rx<XFile?>(null);
  final RxList<XFile> videos = <XFile>[].obs;

  /// Pick single image - Profile Picture
  Future<void> pickProfilePicture(BuildContext context) async {
    final result = await SingleImagePickerDialog.show(
      context,
      IMGType.profilePicture,
    );

    if (result != null) {
      final isValid = await ImagePickerHelper.validateFileSize(
        result,
        maxSizeMB: 5,
      );
      if (isValid) {
        profileImage.value = result;
        Get.snackbar(
          'Success',
          'Profile picture selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[900],
        );
      }
    }
  }

  /// Pick single image - Cover Photo
  Future<void> pickCoverPhoto(BuildContext context) async {
    final result = await SingleImagePickerDialog.show(
      context,
      IMGType.coverPhoto,
    );

    if (result != null) {
      final isValid = await ImagePickerHelper.validateFileSize(
        result,
        maxSizeMB: 10,
      );
      if (isValid) {
        coverImage.value = result;
        Get.snackbar(
          'Success',
          'Cover photo selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[900],
        );
      }
    }
  }

  /// Pick multiple images - Post
  Future<void> pickPostImages(BuildContext context) async {
    final result = await MultipleImagesPickerDialog.show(
      context,
      maxImages: 10,
    );

    if (result != null && result.isNotEmpty) {
      for (final file in result) {
        final isValid = await ImagePickerHelper.validateFileSize(
          file,
          maxSizeMB: 10,
        );
        if (isValid) {
          postImages.add(file);
        }
      }

      if (postImages.isNotEmpty) {
        Get.snackbar(
          'Success',
          '${postImages.length} images added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[900],
        );
      }
    }
  }

  /// Pick video - Story
  Future<void> pickStoryVideo(BuildContext context) async {
    final result = await VideoPickerDialog.show(
      context,
      maxDuration: const Duration(seconds: 30),
    );

    if (result != null) {
      final isValid = await ImagePickerHelper.validateFileSize(
        result,
        maxSizeMB: 50,
      );
      if (isValid) {
        storyVideo.value = result;
        Get.snackbar(
          'Success',
          'Story video selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green[900],
        );
      }
    }
  }

  /// Remove image from post
  void removePostImage(int index) {
    if (index >= 0 && index < postImages.length) {
      postImages.removeAt(index);
    }
  }

  /// Clear all
  void clearAll() {
    profileImage.value = null;
    coverImage.value = null;
    postImages.clear();
    galleryImages.clear();
    storyVideo.value = null;
    videos.clear();
  }
}

// =============================================================================
// EXAMPLE USAGE WIDGET
// =============================================================================
class MediaPickerExample extends StatelessWidget {
  const MediaPickerExample({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MediaPickerController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Picker Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              controller.clearAll();
              Get.snackbar('Cleared', 'All media cleared');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION: Profile Picture (Single Image)
            _buildSectionTitle('Profile Picture (Single)'),
            const SizedBox(height: 12),
            Obx(() => _buildProfileImage(controller)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => controller.pickProfilePicture(context),
              icon: const Icon(Icons.person),
              label: const Text('Pick Profile Picture'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // SECTION: Cover Photo (Single Image)
            _buildSectionTitle('Cover Photo (Single)'),
            const SizedBox(height: 12),
            Obx(() => _buildCoverImage(controller)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => controller.pickCoverPhoto(context),
              icon: const Icon(Icons.landscape),
              label: const Text('Pick Cover Photo'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 32),

            // SECTION: Post Images (Multiple)
            _buildSectionTitle('Post Images (Multiple)'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => controller.pickPostImages(context),
              icon: const Icon(Icons.collections),
              label: const Text('Pick Multiple Images (Max 10)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => _buildPostImagesGrid(controller)),

            const SizedBox(height: 32),

            // SECTION: Story Video
            _buildSectionTitle('Story Video'),
            const SizedBox(height: 12),
            Obx(() => _buildVideoPreview(controller)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => controller.pickStoryVideo(context),
              icon: const Icon(Icons.videocam),
              label: const Text('Pick Story Video (Max 30s)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildProfileImage(MediaPickerController controller) {
    if (controller.profileImage.value != null) {
      return Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 3),
            ),
            child: ClipOval(
              child: Image.file(
                File(controller.profileImage.value!.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.profileImage.value = null,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: const Icon(Icons.person, size: 60, color: Colors.grey),
    );
  }

  Widget _buildCoverImage(MediaPickerController controller) {
    if (controller.coverImage.value != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(controller.coverImage.value!.path),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => controller.coverImage.value = null,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.landscape, size: 60, color: Colors.grey),
    );
  }

  Widget _buildPostImagesGrid(MediaPickerController controller) {
    if (controller.postImages.isEmpty) {
      return Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Text('No images selected')),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: controller.postImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(controller.postImages[index].path),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => controller.removePostImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVideoPreview(MediaPickerController controller) {
    if (controller.storyVideo.value != null) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => controller.storyVideo.value = null,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      );
    }
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.videocam, size: 60, color: Colors.grey),
    );
  }
}
