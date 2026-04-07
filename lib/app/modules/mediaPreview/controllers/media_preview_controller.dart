
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────
// Replace this import with your actual SocialController path
// ─────────────────────────────────────────────────────────────
import 'package:social_book/app/modules/home/social/controllers/social_controller.dart';
import 'package:social_book/app/modules/postUpload/views/post_upload_view.dart';

// ─────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────

enum AspectRatioMode { square, portrait, landscape, original }

enum FilterType { normal, clarendon, gingham, moon, lark, reyes, juno }

// ─────────────────────────────────────────────
// MediaPreviewController
// ─────────────────────────────────────────────

class MediaPreviewController extends GetxController {
  // ── Dependency ────────────────────────────────────────────
  final socialController = Get.find<SocialController>();

  // ── Observables ───────────────────────────────────────────
  final RxInt previewIndex = 0.obs;
  final RxDouble zoom = 1.0.obs;
  final RxBool isMultiSelect = false.obs;
  final RxSet<int> selectedIndices = <int>{}.obs;
  final Rx<AspectRatioMode> aspectRatioMode = AspectRatioMode.square.obs;
  final Rx<FilterType> activeFilter = FilterType.normal.obs;
  final RxBool showFilters = false.obs;

  // ── Computed: preview file ────────────────────────────────
  File? get previewFile {
    final media = socialController.selectedMedia;
    if (media.isEmpty) return null;
    final idx = previewIndex.value.clamp(0, media.length - 1);
    return media[idx].croppedFile;
  }

  // ── Computed: aspect ratio ────────────────────────────────
  double get aspectRatio {
    switch (aspectRatioMode.value) {
      case AspectRatioMode.square:
        return 1.0;
      case AspectRatioMode.portrait:
        return 4 / 5;
      case AspectRatioMode.landscape:
        return 1.91;
      case AspectRatioMode.original:
        return 1.0; // fallback; replace with real image ratio if available
    }
  }

  IconData get aspectRatioIcon {
    switch (aspectRatioMode.value) {
      case AspectRatioMode.square:
        return Icons.crop_square;
      case AspectRatioMode.portrait:
        return Icons.crop_portrait;
      case AspectRatioMode.landscape:
        return Icons.crop_landscape;
      case AspectRatioMode.original:
        return Icons.crop_original;
    }
  }

  String get aspectRatioLabel {
    switch (aspectRatioMode.value) {
      case AspectRatioMode.square:
        return '1:1';
      case AspectRatioMode.portrait:
        return '4:5';
      case AspectRatioMode.landscape:
        return '1.91:1';
      case AspectRatioMode.original:
        return 'Original';
    }
  }

  // ── Zoom ──────────────────────────────────────────────────
  void updateZoom(double scale) {
    zoom.value = (zoom.value * scale).clamp(1.0, 3.0);
  }

  void resetZoom() => zoom.value = 1.0;

  // ── Aspect ratio ──────────────────────────────────────────
  void cycleAspectRatio() {
    final modes = AspectRatioMode.values;
    final next = (aspectRatioMode.value.index + 1) % modes.length;
    aspectRatioMode.value = modes[next];
  }

  // ── Filters ───────────────────────────────────────────────
  void toggleFilters() => showFilters.toggle();

  void setFilter(FilterType filter) => activeFilter.value = filter;

  ColorFilter getColorFilter(FilterType type) {
    switch (type) {
      case FilterType.clarendon:
        return const ColorFilter.matrix([
          1.2,
          0,
          0,
          0,
          10,
          0,
          1.2,
          0,
          0,
          10,
          0,
          0,
          1.5,
          0,
          10,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.gingham:
        return const ColorFilter.matrix([
          1,
          0,
          0,
          0,
          20,
          0,
          1,
          0,
          0,
          10,
          0,
          0,
          0.8,
          0,
          5,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.moon:
        return const ColorFilter.matrix([
          0.3,
          0.6,
          0.1,
          0,
          0,
          0.3,
          0.6,
          0.1,
          0,
          0,
          0.3,
          0.6,
          0.1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.lark:
        return const ColorFilter.matrix([
          1.1,
          0,
          0,
          0,
          15,
          0,
          1.0,
          0,
          0,
          10,
          0,
          0,
          0.9,
          0,
          5,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.reyes:
        return const ColorFilter.matrix([
          0.9,
          0.1,
          0,
          0,
          30,
          0.1,
          0.9,
          0,
          0,
          20,
          0,
          0.1,
          0.8,
          0,
          20,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.juno:
        return const ColorFilter.matrix([
          1.1,
          0,
          0.1,
          0,
          10,
          0,
          1.0,
          0,
          0,
          5,
          0,
          0,
          1.2,
          0,
          10,
          0,
          0,
          0,
          1,
          0,
        ]);
      case FilterType.normal:
        return const ColorFilter.matrix([
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
    }
  }

  // ── Multi-select ──────────────────────────────────────────
  void toggleMultiSelect() {
    isMultiSelect.toggle();
    if (!isMultiSelect.value) selectedIndices.clear();
  }

  // ── Gallery interaction ───────────────────────────────────
  void selectPreview(int index) {
    previewIndex.value = index;
    if (isMultiSelect.value) {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    }



  }

  void removeMedia(int index) {
    socialController.selectedMedia.removeAt(index);
    final len = socialController.selectedMedia.length;
    if (len == 0) {
      Get.back();
      return;
    }
    if (previewIndex.value >= len) {
      previewIndex.value = len - 1;
    }
    // Clean up stale selection indices
    selectedIndices.removeWhere((i) => i >= len);
  }

  // ── Navigation ────────────────────────────────────────────
  void onNext() {
    final mediaList = socialController.selectedMedia;

    if (mediaList.isEmpty) {
      Get.snackbar("Error", "No media selected");
      return;
    }

    // If multi select -> send selected
    if (isMultiSelect.value && selectedIndices.isNotEmpty) {
      final selectedFiles =
          selectedIndices
              .map((i) => mediaList[i].croppedFile)
              .whereType<File>()
              .toList();

      Get.to(
        () => PostUploadView(),
        arguments: {"files": selectedFiles, "filter": activeFilter.value},
      );
    } else {
      // Single preview file
      final file = previewFile;

      if (file == null) return;

      Get.to(
        () => PostUploadView(),
        arguments: {
          "files": [file],
          "filter": activeFilter.value,
        },
      );
    }
  }
}
