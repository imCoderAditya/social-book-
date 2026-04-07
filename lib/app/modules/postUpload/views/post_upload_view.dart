import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/modules/mediaPreview/controllers/media_preview_controller.dart';
import '../controllers/post_upload_controller.dart';

class PostUploadView extends GetView<PostUploadController> {
  const PostUploadView({super.key});

  // ── Design constants ──────────────────────────────────────
  static const _kBg = Color(0xFF000000);
  static const _kSurface = Color(0xFF0E0E0E);
  static const _kBorder = Color(0xFF1F1F1F);
  static const _kAccent = Color(0xFF0095F6);
  static const _kText = Color(0xFFF0EFE9);
  static const _kTextMuted = Color(0xFF6B6A65);
  static const _kTextDim = Color(0xFF3A3A38);
  static const _kDivider = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostUploadController>(
      init: PostUploadController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: _kBg,
          appBar: _buildAppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ① Media carousel
                _buildCarousel(),

                _divider(),

                // ② Caption field
                _buildCaptionSection(),

                _divider(),

                // ③ Details row (Location + Tag people)
                _buildDetailRow(
                  icon: Icons.location_on_outlined,
                  label: 'Add location',
                  child: _buildLocationField(),
                ),

                _divider(),

                _buildDetailRow(
                  icon: Icons.person_add_alt_1_outlined,
                  label: 'Tag people',
                  child: _buildTagSection(),
                ),

                _divider(),

                // ④ Audience selector
                _buildAudienceRow(),

                _divider(),

                // ⑤ Advanced (expandable)
                _buildAdvancedSection(),

                const SizedBox(height: 32),

                // ⑥ Share button
                _buildShareButton(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  // AppBar
  // ─────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _kBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: _kText,
          size: 20,
        ),
        onPressed: Get.back,
      ),
      title: const Text(
        'New Post',
        style: TextStyle(
          color: _kText,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: _kDivider, height: 0.5),
      ),
      actions: [
        Obx(
          () =>
              controller.isUploading.value
                  ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _kAccent,
                      ),
                    ),
                  )
                  : TextButton(
                    onPressed: controller.sharePost,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        color: _kAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // ① Media carousel
  // ─────────────────────────────────────────────────────────
  Widget _buildCarousel() {
    final files = controller.files;

    return Stack(
      children: [
        // PageView
        SizedBox(
          height: 380,
          child: PageView.builder(
            itemCount: files.length,
            onPageChanged: (i) => controller.currentPage.value = i,
            itemBuilder: (_, index) {
              return ColorFiltered(
                colorFilter: _getColorFilter(controller.filter.value!),
                child: Image.file(
                  files[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),

        // Dot indicators (only when multiple files)
        if (files.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(files.length, (i) {
                  final isActive = controller.currentPage.value == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color:
                          isActive ? _kAccent : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ),

        // Media count badge (top-right)
        if (files.length > 1)
          Positioned(
            top: 12,
            right: 12,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.currentPage.value + 1}/${files.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // ② Caption section
  // ─────────────────────────────────────────────────────────
  Widget _buildCaptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar placeholder
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF405DE6), Color(0xFFE1306C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: _kBorder, width: 2),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Caption text field
          Expanded(
            child: TextField(
              controller: controller.captionController,
              maxLines: null,
              minLines: 3,
              maxLength: 2200,
              style: const TextStyle(
                color: _kText,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
              cursorColor: _kAccent,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: const TextStyle(
                  color: _kTextMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                counterStyle: const TextStyle(color: _kTextDim, fontSize: 11),
              ),
            ),
          ),

          // Thumbnail preview
          if (controller.files.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.file(
                controller.files[0],
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ③ Detail row wrapper
  // ─────────────────────────────────────────────────────────
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: _kTextMuted, size: 20),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }

  // Location field
  Widget _buildLocationField() {
    return TextField(
      controller: controller.locationController,
      style: const TextStyle(color: _kText, fontSize: 14),
      cursorColor: _kAccent,
      decoration: const InputDecoration(
        hintText: 'Add location',
        hintStyle: TextStyle(color: _kTextMuted, fontSize: 14),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Tag people section
  // ─────────────────────────────────────────────────────────
  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input
        TextField(
          controller: controller.tagController,
          style: const TextStyle(color: _kText, fontSize: 14),
          cursorColor: _kAccent,
          textInputAction: TextInputAction.done,
          onSubmitted: controller.addTag,
          decoration: const InputDecoration(
            hintText: 'Tag people',
            hintStyle: TextStyle(color: _kTextMuted, fontSize: 14),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),

        // Tag chips
        Obx(
          () =>
              controller.tags.isEmpty
                  ? const SizedBox.shrink()
                  : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children:
                          controller.tags.map((tag) => _tagChip(tag)).toList(),
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _tagChip(String tag) {
    return GestureDetector(
      onTap: () => controller.removeTag(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: _kAccent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _kAccent.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$tag',
              style: const TextStyle(
                color: _kAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.close_rounded, color: _kAccent, size: 12),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ④ Audience selector
  // ─────────────────────────────────────────────────────────
  Widget _buildAudienceRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.public_rounded, color: _kTextMuted, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Audience',
              style: TextStyle(color: _kText, fontSize: 14),
            ),
          ),
          Obx(
            () => GestureDetector(
              onTap: _showAudiencePicker,
              child: Row(
                children: [
                  Text(
                    controller.audience.value,
                    style: const TextStyle(
                      color: _kAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: _kAccent,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAudiencePicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF111111),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Who can see this post?',
                  style: TextStyle(
                    color: _kText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...controller.audienceOptions.map(
              (opt) => Obx(
                () => ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 2,
                  ),
                  title: Text(
                    opt,
                    style: const TextStyle(color: _kText, fontSize: 14),
                  ),
                  trailing:
                      controller.audience.value == opt
                          ? const Icon(
                            Icons.check_rounded,
                            color: _kAccent,
                            size: 20,
                          )
                          : null,
                  onTap: () {
                    controller.audience.value = opt;
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  // ─────────────────────────────────────────────────────────
  // ⑤ Advanced settings (expandable)
  // ─────────────────────────────────────────────────────────
  Widget _buildAdvancedSection() {
    return Column(
      children: [
        // Header row (tap to expand)
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: controller.advancedExpanded.toggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, color: _kTextMuted, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Advanced settings',
                    style: TextStyle(color: _kText, fontSize: 14),
                  ),
                ),
                Obx(
                  () => AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: controller.advancedExpanded.value ? 0.5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _kTextMuted,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expandable body
        Obx(
          () => AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            crossFadeState:
                controller.advancedExpanded.value
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: _buildAdvancedBody(),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedBody() {
    return Container(
      color: _kSurface,
      child: Column(
        children: [
          Obx(
            () => _toggleRow(
              label: 'Allow comments',
              value: controller.allowComments.value,
              onChanged: (v) => controller.allowComments.value = v,
            ),
          ),
          _thinDivider(),
          Obx(
            () => _toggleRow(
              label: 'Allow likes',
              value: controller.allowLikes.value,
              onChanged: (v) => controller.allowLikes.value = v,
            ),
          ),
          _thinDivider(),
          Obx(
            () => _toggleRow(
              label: 'Upload in highest quality',
              subtitle: 'Uses more data',
              value: controller.highQuality.value,
              onChanged: (v) => controller.highQuality.value = v,
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleRow({
    required String label,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: _kText, fontSize: 14),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _kTextMuted, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: _kAccent,
            activeTrackColor: _kAccent.withOpacity(0.3),
            inactiveTrackColor: _kTextDim,
            inactiveThumbColor: _kTextMuted,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // ⑥ Share button
  // ─────────────────────────────────────────────────────────
  Widget _buildShareButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color:
                controller.isUploading.value
                    ? _kAccent.withOpacity(0.5)
                    : _kAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: controller.isUploading.value ? null : controller.sharePost,
              child: Center(
                child:
                    controller.isUploading.value
                        ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                        : const Text(
                          'Share Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────
  Widget _divider() => Container(color: _kDivider, height: 0.5);

  Widget _thinDivider() => Padding(
    padding: const EdgeInsets.only(left: 16),
    child: Container(color: _kDivider, height: 0.5),
  );

  /// Re-applies the ColorFilter from media preview.
  ColorFilter _getColorFilter(FilterType type) {
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
}
