// ignore_for_file: unused_field, deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/constant/constants.dart';
import 'package:social_book/app/data/models/reels/reels_model.dart';
import 'package:social_book/app/modules/reels/widgets/reels_comment_widget.dart';

import 'package:video_player/video_player.dart';
import '../controllers/reels_controller.dart';

class ReelsView extends GetView<ReelsController> {
  final int? currentIndex;
  const ReelsView({super.key, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReelsController>(
      init: ReelsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          body: Obx(() {
            if (controller.reelList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            return currentIndex == 1
                ? PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: controller.reelList.length + 1,
                  onPageChanged: controller.onPageChanged,
                  controller: controller.pageController,

                  itemBuilder: (context, index) {
                    if (index < controller.reelList.length) {
                      final reels = controller.reelList[index];
                      return _ReelItem(
                        reel: reels,
                        isCurrentPage: controller.currentIndex.value == index,
                        index: index,
                      );
                    } else {
                      return Obx(() {
                        return controller.isLoading.value
                            ? ReelItemShimmer()
                            : const SizedBox();
                      });
                    }
                  },
                )
                : SizedBox();
          }),
        );
      },
    );
  }
}

class _ReelItem extends StatefulWidget {
  final ReelData? reel;
  final bool isCurrentPage;
  final int? index;

  const _ReelItem({
    required this.reel,
    required this.isCurrentPage,
    this.index,
  });

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  late AnimationController _animationController;
  final bool _isLiked = false;
  final bool _isFollowing = false;
  final bool _showHeart = false;
  ScrollController scrollController = ScrollController();
  final controller =
      Get.isRegistered<ReelsController>()
          ? Get.find<ReelsController>()
          : Get.put(ReelsController());
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.network(
      widget.reel?.mediaUrl ?? "",
    );

    try {
      await _videoController!.initialize();
      if (!mounted) return;

      setState(() {});

      if (widget.isCurrentPage) {
        _videoController?.play();
        log("isCurrentPage");
        _videoController?.setLooping(true);
      } else {
        log("Not Page Current Page");
        _videoController?.pause();
      }
    } catch (e) {
      debugPrint('Video init error: $e');
    }

    // Set controller to ReelsController
    Get.find<ReelsController>().setController(_videoController!);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _animationController.dispose();

    super.dispose();
  }

  // ignore: unused_element

  @override
  Widget build(BuildContext context) {
    debugPrint("IsLike ===${widget.reel?.isLiked}");
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onDoubleTap: () => controller.likeDoubleTap(widget.index ?? 0),
      onTap: () {
        if (_videoController!.value.isPlaying) {
          _videoController?.pause();
          log("pause");
        } else {
          _videoController?.play();
          log("play");
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video/Image Background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:
                _videoController?.value.isInitialized == true
                    ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _videoController!.value.size.width,
                        height: _videoController!.value.size.height,
                        child: VideoPlayer(_videoController!),
                      ),
                    )
                    : Container(
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
          ),

          // Top Gradient Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
          ),

          // Bottom Gradient Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
          ),

          // Top Bar (Camera & Title)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
          ),

          // Right Side Actions
          Positioned(
            right: 12,
            bottom: 100,
            child: Column(
              children: [
                // _ActionButton(
                //   icon:
                //       (widget.reel?.myReactionType == "Like")
                //           ? Icons.favorite
                //           : Icons.favorite_border,
                //   label: _formatCount(widget.reel?.totalLikes ?? 0),
                //   onTap: () => controller.toggleLike(widget.index ?? 0),
                //   color:
                //       (widget.reel?.myReactionType == "Like")
                //           ? Colors.red
                //           : Colors.white,
                // ),
                Obx(() {
                  final reel = controller.reelList[widget.index ?? 0];

                  return _ActionButton(
                    icon:
                        reel.isLiked == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                    label: formatCount(reel.totalLikes ?? 0),
                    color: reel.isLiked == true ? Colors.red : Colors.white,
                    onTap: () => controller.toggleLike(widget.index ?? 0),
                  );
                }),

                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.mode_comment_outlined,
                  label:
                      controller.totalComment.value == 0
                          ? ""
                          : formatCount(controller.totalComment.value),
                  onTap:
                      () async => {
                        _showComments(context),
                        await controller.fetchComments(
                          postId: widget.reel?.postId,
                          profileId: controller.profileId,
                        ),
                      },
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.send_outlined,
                  label: 'Share',
                  onTap: () async {
                    final url = widget.reel?.mediaUrl ?? "";
                    if (url.isNotEmpty) {
                      await Share.share(
                        url,
                        subject: 'Check out this awesome reel!',
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('')));
                    }
                  },
                ),
                const SizedBox(height: 20),
                _ActionButton(
                  icon: Icons.more_vert,
                  label: '',
                  onTap: () => _showOptions(context),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      image: NetworkImage(widget.reel?.thumbnailUrl ?? ""),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Info
          Positioned(
            left: 16,
            right: 80,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(
                        widget.reel?.profilePicture ?? "",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.reel?.displayName ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.reel?.content ?? "",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.reel?.postType ?? "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () =>
                controller.isLikeDoubletab.value
                    ? AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: controller.heartOpacity.value,
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        scale: controller.heartScale.value,
                        child: Icon(
                          Icons.favorite,
                          size: 120.h,
                          color:
                              widget.reel?.isLiked == true
                                  ? AppColors.red
                                  : AppColors.white,
                        ),
                      ),
                    )
                    : const SizedBox(),
          ),
        ],
      ),
    );
  }

  void _showComments(BuildContext context) {
    if (Get.isBottomSheetOpen ?? false) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ReelsCommentWidget(),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _OptionTile(icon: Icons.bookmark_border, text: 'Save'),
                _OptionTile(icon: Icons.flag_outlined, text: 'Report'),
                _OptionTile(icon: Icons.block, text: 'Not Interested'),
                _OptionTile(
                  icon: Icons.person_add_outlined,
                  text: 'About this account',
                ),
                _OptionTile(icon: Icons.link, text: 'Copy Link'),
                _OptionTile(icon: Icons.share_outlined, text: 'Share to...'),
              ],
            ),
          ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _OptionTile({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[800]),
      title: Text(text),
      onTap: () => Navigator.pop(context),
    );
  }
}

// Shimmer Effect Class

class ReelItemShimmer extends StatelessWidget {
  const ReelItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey[900]!,
          highlightColor: Colors.grey[700]!,
          child: Container(color: Colors.black),
        ),

        // Top Gradient Overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
        ),

        // Bottom Gradient Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
        ),

        // Top Bar Shimmer
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[600]!,
                  highlightColor: Colors.grey[400]!,
                  child: Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[600]!,
                  highlightColor: Colors.grey[400]!,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Side Actions Shimmer
        Positioned(
          right: 12,
          bottom: 100,
          child: Column(
            children: List.generate(
              5,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[600]!,
                  highlightColor: Colors.grey[400]!,
                  child: Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      if (index < 3) ...[
                        const SizedBox(height: 4),
                        Container(
                          width: 30,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Bottom Info Shimmer
        Positioned(
          left: 16,
          right: 80,
          bottom: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile row shimmer
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(
                      width: 100,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(
                      width: 60,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Description shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey[600]!,
                highlightColor: Colors.grey[400]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 200,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Music shimmer
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[600]!,
                    highlightColor: Colors.grey[400]!,
                    child: Container(
                      width: 150,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Loading indicator in center
        Center(
          child: CircularProgressIndicator(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ],
    );
  }
}
