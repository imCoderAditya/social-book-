import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/modules/mediaPreview/controllers/media_preview_controller.dart';


// ─────────────────────────────────────────────────────────────────────────────
// MediaPreviewView
// ─────────────────────────────────────────────────────────────────────────────
//
// Instagram-style media preview screen.
//
// Dependencies (must be registered before navigating here):
//   Get.put(SocialController())        ← already registered upstream
//   Get.put(MediaPreviewController())  ← register before Get.to(MediaPreviewView)
//
// Usage:
//   Get.put(MediaPreviewController());
//   Get.to(() => MediaPreviewView());
// ─────────────────────────────────────────────────────────────────────────────

class MediaPreviewView extends StatelessWidget {
  MediaPreviewView({super.key});

  final MediaPreviewController c = Get.find<MediaPreviewController>();

  // ── Constants ─────────────────────────────────────────────
  static const _kAccent = Color(0xFF0095F6);
  static const _kGridGap = 1.5;
  static const _kFilterStripHeight = 100.0;
  static const _kFilterThumbSize = 60.0;

  // ─────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MediaPreviewController>(
      init: MediaPreviewController(),
      builder: (c) {
        return Scaffold(
          backgroundColor: AppColors.black,
          appBar: _buildAppBar(),
          body: Obx(() {
            if (c.socialController.selectedMedia.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: _kAccent),
              );
            }
            return Column(
              children: [
                // ① Main preview
                _buildMainPreview(), 
        
                // ② Toolbar
                _buildToolbar(),
        
                // ③ Filter strip (conditional)
                Obx(() => c.showFilters.value
                    ? _buildFilterStrip()
                    : const SizedBox.shrink()),
        
                // ④ Gallery grid (fills remaining space)
                Expanded(child: _buildGalleryGrid()),
              ],
            );
          }),
        );
      }
    );
  }

  // ─────────────────────────────────────────────────────────
  // ① AppBar
  // ─────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: Get.back,
      ),
      title: const Text(
        'New Post',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: c.onNext,
          child: const Text(
            'Next',
            style: TextStyle(
              color: _kAccent,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // ② Main preview
  // ─────────────────────────────────────────────────────────
  Widget _buildMainPreview() {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: AspectRatio(
            aspectRatio: c.aspectRatio,
            child: GestureDetector(
              onScaleUpdate: (details) => c.updateZoom(details.scale),
              onDoubleTap: c.resetZoom,
              child: ClipRect(
                child: Transform.scale(
                  scale: c.zoom.value,
                  child: _filteredImage(
                    c.previewFile,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  // ─────────────────────────────────────────────────────────
  // ③ Toolbar
  // ─────────────────────────────────────────────────────────
  Widget _buildToolbar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // Aspect ratio chip
          Obx(() => _chip(
                icon: c.aspectRatioIcon,
                label: c.aspectRatioLabel,
                onTap: c.cycleAspectRatio,
              )),

          const Spacer(),

          // Reset zoom – visible only when zoomed in
          Obx(() => c.zoom.value > 1.0
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _chip(
                    icon: Icons.zoom_out_map,
                    label: 'Reset',
                    onTap: c.resetZoom,
                  ),
                )
              : const SizedBox.shrink()),

          // Filter toggle
          Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _chip(
                  icon: Icons.auto_awesome,
                  label: 'Filter',
                  active: c.showFilters.value,
                  onTap: c.toggleFilters,
                ),
              )),

          // Multi-select toggle
          Obx(() => _chip(
                icon: Icons.select_all,
                label: 'Select',
                active: c.isMultiSelect.value,
                onTap: c.toggleMultiSelect,
              )),
        ],
      ),
    );
  }

  /// Pill-shaped toolbar chip (default / active states).
  Widget _chip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: active ? Colors.black : Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ④ Filter strip
  // ─────────────────────────────────────────────────────────
  Widget _buildFilterStrip() {
    final filters = FilterType.values;
    return Container(
      height: _kFilterStripHeight,
      color: Colors.black,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: filters.length,
        itemBuilder: (_, index) {
          final filter = filters[index];
          return Obx(() {
            final isActive = c.activeFilter.value == filter;
            return GestureDetector(
              onTap: () => c.setFilter(filter),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    // Thumbnail with accent border when active
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isActive ? _kAccent : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          width: _kFilterThumbSize,
                          height: _kFilterThumbSize,
                          child: c.previewFile != null
                              ? ColorFiltered(
                                  colorFilter:
                                      c.getColorFilter(filter),
                                  child: Image.file(
                                    c.previewFile!,
                                    fit: BoxFit.cover,
                                    cacheWidth: 120,
                                  ),
                                )
                              : Container(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Filter name
                    Text(
                      filter.name[0].toUpperCase() +
                          filter.name.substring(1),
                      style: TextStyle(
                        color: isActive ? _kAccent : Colors.white70,
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ⑤ Gallery grid
  // ─────────────────────────────────────────────────────────
 Widget _buildGalleryGrid() {
  return Obx(() {
    final media = c.socialController.selectedMedia;
    final previewIndex = c.previewIndex.value;
    final selected = c.selectedIndices;
    final isMulti = c.isMultiSelect.value;

    return GridView.builder(
      padding: const EdgeInsets.only(top: _kGridGap),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: _kGridGap,
        mainAxisSpacing: _kGridGap,
      ),
      itemCount: media.length,
      itemBuilder: (_, index) {
        final file = media[index].croppedFile;

        final isActive = previewIndex == index;
        final isSelected = selected.contains(index);
        final order = selected.toList().indexOf(index) + 1;

        return GestureDetector(
          onTap: () => c.selectPreview(index),
          child: _GalleryCell(
            file: file,
            isActive: isActive,
            isSelected: isSelected,
            isMulti: isMulti,
            order: order,
            onRemove: () => c.removeMedia(index),
          ),
        );
      },
    );
  });
}
  // ─────────────────────────────────────────────────────────
  // Helper: filtered image
  // ─────────────────────────────────────────────────────────
  Widget _filteredImage(
    File? file, {
    BoxFit fit = BoxFit.cover,
    double? width,
  }) {
    if (file == null) return const SizedBox.shrink();
    return Obx(() => ColorFiltered(
          colorFilter: c.getColorFilter(c.activeFilter.value),
          child: Image.file(file, fit: fit, width: width),
        ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _GalleryCell
//
// A single cell in the gallery grid. Fully stateless — all reactive data
// is passed in from the parent Obx so this widget never needs to rebuild
// independently.
// ─────────────────────────────────────────────────────────────────────────────
class _GalleryCell extends StatelessWidget {
  const _GalleryCell({
    required this.file,
    required this.isActive,
    required this.isSelected,
    required this.isMulti,
    required this.order,
    required this.onRemove,
  });

  final File? file;
  final bool isActive;
  final bool isSelected;
  final bool isMulti;
  final int order; // 1-based; 0 = not in selectedIndices
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── 1. Thumbnail ──────────────────────────────────
        _Thumbnail(file: file),

        // ── 2. Dim overlay ────────────────────────────────
        // Hidden when cell is active OR selected in multi-mode.
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity:
              (isActive || (isMulti && isSelected)) ? 0.0 : 0.38,
          child: const ColoredBox(color: Colors.black),
        ),

        // ── 3. Accent border (active cell) ────────────────
        AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isActive ? 1.0 : 0.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF0095F6),
                width: 2.5,
              ),
            ),
          ),
        ),

        // ── 4a. Multi-select numbered badge ───────────────
        if (isMulti) _SelectBadge(order: order, selected: isSelected),

        // ── 4b. Single-select remove button ───────────────
        if (!isMulti)
          Positioned(
            top: 4,
            right: 4,
            child: _RemoveButton(onTap: onRemove),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _Thumbnail
// ─────────────────────────────────────────────────────────────────────────────
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.file});

  final File? file;

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return const ColoredBox(color: Color(0xFF1C1C1C));
    }
    return Image.file(
      file!,
      fit: BoxFit.cover,
      cacheWidth: 200, // downsample for grid performance
      gaplessPlayback: true,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SelectBadge
//
// Circular numbered badge shown in multi-select mode.
// Empty circle → not selected.
// Filled accent circle with number → selected (1-based order).
// ─────────────────────────────────────────────────────────────────────────────
class _SelectBadge extends StatelessWidget {
  const _SelectBadge({required this.order, required this.selected});

  final int order;
  final bool selected;

  static const _kAccent = Color(0xFF0095F6);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6,
      right: 6,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? _kAccent : Colors.transparent,
          border: Border.all(
            color: selected ? _kAccent : Colors.white,
            width: 1.5,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: selected
            ? Text(
                '$order',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RemoveButton
//
// Small ✕ button shown in the top-right corner of each cell in
// single-select mode. Tapping calls the parent's removeMedia callback.
// ─────────────────────────────────────────────────────────────────────────────
class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          color: Color(0x99000000),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 13,
        ),
      ),
    );
  }
}