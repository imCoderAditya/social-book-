import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_book/app/data/models/media/picked_media_result.dart' show PickedMediaResult, PickedMediaType;

class MediaPickerUtil {
  static final ImagePicker _picker = ImagePicker();

  /// Common function to pick image or video
  static Future<PickedMediaResult?> pickMedia({
    required ImageSource source,
    bool pickImage = true,
    bool pickVideo = false,
    int imageQuality = 80,
    Duration? maxVideoDuration,
  }) async {
    try {
      // IMAGE
      if (pickImage) {
        final XFile? image = await _picker.pickImage(
          source: source,
          imageQuality: imageQuality,
        );

        if (image != null) {
          return PickedMediaResult(
            file: image,
            type: PickedMediaType.image,
          );
        }
      }

      // VIDEO
      if (pickVideo) {
        final XFile? video = await _picker.pickVideo(
          source: source,
          maxDuration: maxVideoDuration,
        );

        if (video != null) {
          return PickedMediaResult(
            file: video,
            type: PickedMediaType.video,
          );
        }
      }
    } catch (e) {
      debugPrint("❌ Media pick error: $e");
    }

    return null;
  }
}
