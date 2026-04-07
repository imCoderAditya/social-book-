import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class InstaPickerService {

  static Future<void> pickMedia({
    required void Function(Stream<InstaAssetsExportDetails>) onCompleted,
  }) async {

    final context = Get.context;

    if (context == null) return;

    await InstaAssetPicker.pickAssets(
      context,
      maxAssets: 10,

      pickerConfig: InstaAssetPickerConfig(

        specialItemPosition: SpecialItemPosition.prepend,

        cropDelegate: const InstaAssetCropDelegate(
          cropRatios: [1 / 1, 4 / 5, 16 / 9],
        ),

        specialItemBuilder: (context, path, length) {

          return GestureDetector(
            onTap: () async {

              final entity = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: const CameraPickerConfig(
                  enableRecording: true,
                ),
              );

              if (entity != null) {
                Get.snackbar(
                  "Camera",
                  "Photo captured",
                  snackPosition: SnackPosition.BOTTOM,
                );
              }

            },
            child: Container(
              color: Colors.grey[900],
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          );
        },
      ),

      onCompleted: onCompleted,
    );
  }
}