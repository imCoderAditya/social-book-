import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/modules/home/social/controllers/social_controller.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:video_player/video_player.dart';
import '../controllers/story_controller.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  STORY TRAY  (horizontal scroll bar on home feed)
// ═══════════════════════════════════════════════════════════════════════════

class StoryView extends GetView<StoryController> {
  const StoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ensure controller is registered
    if (!Get.isRegistered<StoryController>()) Get.put(StoryController());

    return Obx(() {
      if (controller.isLoading.value && controller.storyGroups.isEmpty) {
        return _buildLoadingState(isDark);
      }

      // friendGroups excludes index-0 (My Story)
      final friends = controller.friendGroups;

      return Container(
        height: 110.h,
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          // +1 for My Story item at index 0
          itemCount: friends.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _buildMyStoryItem(context, isDark);

            final group = friends[index - 1];
            final isViewed = controller.isGroupFullyViewed(group);

            return _buildFriendStoryItem(
              context: context,
              isDark: isDark,
              group: group,
              isViewed: isViewed,
              // +1 offset because storyGroups[0] = my story
              groupIndex: index,
            );
          },
        ),
      );
    });
  }

  // ── My Story item ────────────────────────────────────────────────────────

  // Widget _buildMyStoryItem(BuildContext context, bool isDark) {
  //   final profileController = Get.isRegistered<ProfileController>()
  //       ? Get.find<ProfileController>()
  //       : Get.put(ProfileController());

  //   final String userImg =
  //       profileController.userProfileModel.value?.data?.profilePictureUrl ?? '';

  //   return Obx(() {
  //     final hasStory = controller.hasMyStory();

  //     return Padding(
  //       padding: EdgeInsets.only(right: 12.w),
  //       child: GestureDetector(
  //         onTap: () => _onMyStoryTap(context, hasStory),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             _StoryRing(
  //               imageUrl: userImg,
  //               isViewed: false,
  //               hasStory: hasStory,
  //               showAddButton: !hasStory,
  //               isDark: isDark,
  //             ),
  //             SizedBox(height: 6.h),
  //             Text(
  //               hasStory ? 'Your Story' : 'Add Story',
  //               style: TextStyle(
  //                 color: isDark ? Colors.white : Colors.black87,
  //                 fontSize: 12.sp,
  //                 fontWeight: FontWeight.w400,
  //               ),
  //               maxLines: 1,
  //               overflow: TextOverflow.ellipsis,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }
Widget _buildMyStoryItem(BuildContext context, bool isDark) {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    final String userImg =
        profileController.userProfileModel.value?.data?.profilePictureUrl ?? '';

    return Obx(() {
      final hasStory = controller.hasMyStory();

      return Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: GestureDetector(
          onTap: () => _onMyStoryTap(context, hasStory),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _StoryRing(
                    imageUrl: userImg,
                    isViewed: false,
                    hasStory: hasStory,
                    isDark: isDark,
                  ),
                  // + button always visible in bottom-right corner
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _onAddStoryTap(context),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                hasStory ? 'Your Story' : 'Add Story',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    });
  }

  /// Tapping the avatar area:
  /// - Has story  → open viewer
  /// - No story   → go to story creation
  void _onMyStoryTap(BuildContext context, bool hasStory) {
    if (hasStory) {
      controller.openMyStory();
      _pushViewer(context);
    } else {
      _onAddStoryTap(context);
    }
  }

  /// Tapping the + button ALWAYS opens story creation,
  /// even when the user already has an active story.
  void _onAddStoryTap(BuildContext context) {
    final socialController = Get.isRegistered<SocialController>()
        ? Get.find<SocialController>()
        : Get.put(SocialController());
    socialController.pickImages();
  }
  // void _onMyStoryTap(BuildContext context, bool hasStory) {
  //   if (hasStory) {
  //     // Open My Story viewer (group index 0)
  //     controller.openMyStory();
  //     _pushViewer(context);
  //   } else {
  //     // No story yet → open story creation
  //     final socialController = Get.isRegistered<SocialController>()
  //         ? Get.find<SocialController>()
  //         : Get.put(SocialController());
  //     socialController.pickImages();
  //   }
  // }

  // ── Friend story item ────────────────────────────────────────────────────

  Widget _buildFriendStoryItem({
    required BuildContext context,
    required bool isDark,
    required StoryGroup group,
    required bool isViewed,
    required int groupIndex,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: GestureDetector(
        onTap: () {
          controller.openGroupAtIndex(groupIndex);
          _pushViewer(context);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StoryRing(
              imageUrl: group.profilePicture ?? '',
              isViewed: isViewed,
              hasStory: true,
              isDark: isDark,
              fallbackLetter: (group.displayName?.isNotEmpty == true)
                  ? group.displayName![0].toUpperCase()
                  : 'U',
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: 68.w,
              child: Text(
                group.displayName ?? 'User',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushViewer(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, _) => const StoryViewerScreen(),
        transitionsBuilder: (ctx, anim, _, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(position: anim.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 280),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      height: 110.h,
      alignment: Alignment.center,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Reusable gradient ring avatar used in the story tray.
// ─────────────────────────────────────────────────────────────────────────────
class _StoryRing extends StatelessWidget {
  final String imageUrl;
  final bool isViewed;
  final bool hasStory;
  final bool showAddButton;
  final bool isDark;
  final String? fallbackLetter;

  const _StoryRing({
    required this.imageUrl,
    required this.isViewed,
    required this.hasStory,
    this.showAddButton = false,
    required this.isDark,
    this.fallbackLetter,
  });

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        isViewed ? Colors.grey.shade400 : AppColors.primaryColor;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 68.w,
          height: 68.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (!isViewed && hasStory)
                ? LinearGradient(
                    colors: [AppColors.primaryColor, AppColors.secondaryPrimary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            border: (isViewed || !hasStory)
                ? Border.all(color: borderColor, width: 2)
                : null,
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: imageUrl.isNotEmpty
                  ? CommonNetworkImage(
                      imageUrl: imageUrl,
                      width: 68.w,
                      height: 68.w,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.zero,
                      errorWidget: _fallback(),
                    )
                  : _fallback(),
            ),
          ),
        ),
        if (showAddButton)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 14, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }

  Widget _fallback() {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.12),
      child: Center(
        child: fallbackLetter != null
            ? Text(
                fallbackLetter!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.sp,
                  color: AppColors.primaryColor,
                ),
              )
            : Icon(Icons.person, color: AppColors.primaryColor, size: 28.sp),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  STORY VIEWER SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({super.key});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  final StoryController controller = Get.find<StoryController>();

  late AnimationController _animController;
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _replyFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markCurrentStoryAsViewed();
      controller.startStoryTimer();
    });

    _replyFocusNode.addListener(() {
      if (_replyFocusNode.hasFocus) {
        controller.pauseStory();
      } else {
        controller.resumeStory();
      }
    });
  }

  @override
  void dispose() {
    controller.pauseStory();
    _animController.dispose();
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Obx(() {
        final story = controller.getCurrentStory();

        if (story == null) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        return GestureDetector(
          onTapUp: (d) {
            if (!_replyFocusNode.hasFocus) {
              controller.onStoryTap(d, screenWidth);
            }
          },
          onLongPressStart: (_) => controller.onLongPressStart(),
          onLongPressEnd: (_) => controller.onLongPressEnd(),
          onVerticalDragEnd: (d) {
            if ((d.primaryVelocity ?? 0) > 300) Get.back();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. MEDIA (image / video / text) ──────────────────────────
              _buildMediaContent(story),

              // ── 2. TOP SCRIM ──────────────────────────────────────────────
              _buildGradient(top: true),

              // ── 3. BOTTOM SCRIM ───────────────────────────────────────────
              _buildGradient(top: false),

              // ── 4. PROGRESS BARS ──────────────────────────────────────────
              Positioned(
                top: padding.top + 8.h,
                left: 8.w,
                right: 8.w,
                child: _buildProgressBars(),
              ),

              // ── 5. HEADER (avatar + name + time + menu) ───────────────────
              Positioned(
                top: padding.top + 26.h,
                left: 12.w,
                right: 8.w,
                child: _buildUserHeader(story),
              ),

              // // ── 6. BOTTOM ROW (reply / like / share  OR  viewers) ─────────
              // Positioned(
              //   bottom: padding.bottom + 12.h,
              //   left: 12.w,
              //   right: 12.w,
              //   child: controller.isMyStory()
              //       ? _buildMyStoryBottom()
              //       : _buildFriendStoryBottom(),
              // ),
            ],
          ),
        );
      }),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  MEDIA CONTENT
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildMediaContent(UnifiedStory story) {
    if (story.isVideo) {
      return VideoStoryPlayer(
        key: ValueKey(story.mediaUrl ?? ''),
        videoUrl: story.mediaUrl ?? '',
        isMuted: controller.isMuted.value,
        onVideoEnd: () => controller.nextStory(),
        onVideoReady: (duration) {
          // Override timer duration to match video length
          controller.pauseStory();
          controller.startStoryTimer(overrideDuration: duration.inSeconds);
        },
      );
    }

    if (story.isText) {
      return _TextStoryContent(story: story);
    }

    // Default → image
    return CommonNetworkImage(
      imageUrl: story.mediaUrl ?? '',
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      backgroundColor: Colors.black,
      borderRadius: BorderRadius.zero,
      errorWidget: _mediaErrorWidget(isVideo: false),
    );
  }

  Widget _mediaErrorWidget({required bool isVideo}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isVideo ? Icons.videocam_off : Icons.broken_image,
            size: 60.sp,
            color: Colors.white54,
          ),
          SizedBox(height: 10.h),
          Text(
            isVideo ? 'Failed to load video' : 'Failed to load image',
            style: TextStyle(color: Colors.white54, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  OVERLAYS
  // ═════════════════════════════════════════════════════════════════════════

  Widget _buildGradient({required bool top}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      child: Container(
        height: 160.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: top ? Alignment.topCenter : Alignment.bottomCenter,
            end: top ? Alignment.bottomCenter : Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.75),
              Colors.black.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  // ── Progress bars ─────────────────────────────────────────────────────────

  Widget _buildProgressBars() {
    final group = controller.currentGroup;
    if (group == null || group.stories.isEmpty) return const SizedBox.shrink();

    return Row(
      children: List.generate(group.stories.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Obx(() {
              double progress = 0.0;
              if (index < controller.currentStoryIndex.value) {
                progress = 1.0;
              } else if (index == controller.currentStoryIndex.value) {
                progress = controller.storyProgress.value;
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(2.r),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 3.h,
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  // ── User header ───────────────────────────────────────────────────────────

  Widget _buildUserHeader(UnifiedStory story) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: story.profilePicture?.isNotEmpty == true
                ? CommonNetworkImage(
                    imageUrl: story.profilePicture!,
                    width: 36.w,
                    height: 36.w,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  )
                : Container(
                    color: AppColors.primaryColor,
                    child: const Icon(Icons.person,
                        color: Colors.white, size: 20),
                  ),
          ),
        ),
        SizedBox(width: 10.w),
        // Name + timestamp
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                story.isMyStory
                    ? 'Your Story'
                    : (story.displayName ?? 'User'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _timeAgo(story.createdDate),
                style: TextStyle(
                    color: Colors.white.withOpacity(0.75), fontSize: 11.sp),
              ),
            ],
          ),
        ),
        // Mute button
        Obx(() => IconButton(
              icon: Icon(
                controller.isMuted.value
                    ? Icons.volume_off_rounded
                    : Icons.volume_up_rounded,
                color: Colors.white,
                size: 22,
              ),
              onPressed: controller.toggleMute,
            )),
        // Close / Options
        if (controller.isMyStory())
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 26),
            onPressed: Get.back,
          )
        // else
          // IconButton(
          //   icon:
          //       const Icon(Icons.more_vert, color: Colors.white, size: 26),
          //   onPressed: _showStoryOptions,
          // ),
      ],
    );
  }

  // ── My Story bottom: viewers ───────────────────────────────────────────────

  Widget _buildMyStoryBottom() {
    return Obx(() {
      final count = controller.currentStoryViewCount.value;
      return GestureDetector(
        onTap: _showViewersList,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.remove_red_eye_outlined,
                  color: Colors.white, size: 20),
              SizedBox(width: 6.w),
              Text(
                '$count views',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Friend story bottom: reply + like + share ──────────────────────────────

  Widget _buildFriendStoryBottom() {
    return Row(
      children: [
        // Reply field
        Expanded(
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70, width: 1.5),
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: TextField(
              controller: _replyController,
              focusNode: _replyFocusNode,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Send message…',
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.55), fontSize: 14.sp),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 11.h),
                suffixIcon: ValueListenableBuilder(
                  valueListenable: _replyController,
                  builder: (_, v, __) => v.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.white, size: 20),
                          onPressed: _sendReply,
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              onSubmitted: (_) => _sendReply(),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        // Like
        _CircleAction(
          icon: Icons.favorite_border_rounded,
          onTap: () {
            controller.likeStory();
            _showLikeAnimation();
          },
        ),
        SizedBox(width: 6.w),
        // Share
        _CircleAction(
          icon: Icons.send_rounded,
          rotate: -0.5,
          onTap: controller.shareStory,
        ),
      ],
    );
  }

  // ═════════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═════════════════════════════════════════════════════════════════════════

  void _sendReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    controller.sendReply(text);
    _replyController.clear();
    _replyFocusNode.unfocus();
    Get.snackbar(
      'Sent',
      'Your reply has been sent',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white.withOpacity(0.2),
      colorText: Colors.white,
      margin: EdgeInsets.all(10.w),
    );
  }

  void _showLikeAnimation() {
    // Overlay a big heart for a brief moment
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(milliseconds: 700),
      backgroundColor: Colors.transparent,
      messageText: const Icon(Icons.favorite_rounded,
          color: Colors.red, size: 80),
      margin: EdgeInsets.zero,
    );
  }

  void _showViewersList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ViewersBottomSheet(),
    );
  }

  void _showStoryOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _StoryOptionsSheet(controller: controller),
    );
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return 'Just now';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inSeconds < 60) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return 'Just now';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Text-only story background
// ─────────────────────────────────────────────────────────────────────────────
class _TextStoryContent extends StatelessWidget {
  final UnifiedStory story;
  const _TextStoryContent({required this.story});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.secondaryPrimary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            story.content ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
              shadows: const [
                Shadow(color: Colors.black38, blurRadius: 8)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Small icon button used in the reply row
// ─────────────────────────────────────────────────────────────────────────────
class _CircleAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double rotate;

  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.rotate = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Transform.rotate(
          angle: rotate,
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Viewers bottom sheet (My Story only)
// ─────────────────────────────────────────────────────────────────────────────
class _ViewersBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 400.h,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Text('Viewers',
              style: TextStyle(
                  fontSize: 16.sp, fontWeight: FontWeight.bold)),
          Divider(height: 20.h),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  child: Text('U${i + 1}',
                      style: const TextStyle(color: Colors.white)),
                ),
                title: Text('User ${i + 1}'),
                subtitle: Text('${i + 1}h ago'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
/// Options bottom sheet (Friend stories only)
// ─────────────────────────────────────────────────────────────────────────────
class _StoryOptionsSheet extends StatelessWidget {
  final StoryController controller;
  const _StoryOptionsSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 8.h),
          ListTile(
            leading:
                const Icon(Icons.report_outlined, color: Colors.redAccent),
            title: const Text('Report'),
            onTap: () {
              Get.back();
              controller.reportStory();
            },
          ),
          ListTile(
            leading: const Icon(Icons.block_outlined),
            title: const Text('Block user'),
            onTap: () {
              Get.back();
              controller.blockUser();
            },
          ),
          ListTile(
            leading: const Icon(Icons.volume_off_outlined),
            title: const Text('Mute stories'),
            onTap: () {
              Get.back();
              controller.muteUserStories();
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
//  VIDEO STORY PLAYER
// ═══════════════════════════════════════════════════════════════════════════

class VideoStoryPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback onVideoEnd;
  final ValueChanged<Duration>? onVideoReady;
  final bool isMuted;

  const VideoStoryPlayer({
    super.key,
    required this.videoUrl,
    required this.onVideoEnd,
    this.onVideoReady,
    this.isMuted = false,
  });

  @override
  State<VideoStoryPlayer> createState() => _VideoStoryPlayerState();
}

class _VideoStoryPlayerState extends State<VideoStoryPlayer> {
  late VideoPlayerController _vc;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _endCallbackFired = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void didUpdateWidget(VideoStoryPlayer old) {
    super.didUpdateWidget(old);
    if (old.isMuted != widget.isMuted) {
      _vc.setVolume(widget.isMuted ? 0 : 1);
    }
  }

  void _initVideo() {
    if (widget.videoUrl.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    _vc = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _isInitialized = true);
        _vc
          ..setLooping(false)
          ..setVolume(widget.isMuted ? 0 : 1)
          ..play();

        widget.onVideoReady?.call(_vc.value.duration);

        _vc.addListener(_videoListener);
      }).catchError((e) {
        debugPrint('VideoPlayer error: $e');
        if (mounted) setState(() => _hasError = true);
      });
  }

  void _videoListener() {
    if (!_vc.value.isInitialized) return;
    final pos = _vc.value.position;
    final dur = _vc.value.duration;
    if (!_endCallbackFired && dur.inMilliseconds > 0 && pos >= dur) {
      _endCallbackFired = true;
      widget.onVideoEnd();
    }
  }

  @override
  void dispose() {
    _vc.removeListener(_videoListener);
    _vc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off_rounded,
                size: 60.sp, color: Colors.white54),
            SizedBox(height: 10.h),
            Text('Failed to load video',
                style: TextStyle(color: Colors.white54, fontSize: 14.sp)),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      );
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _vc.value.aspectRatio,
        child: VideoPlayer(_vc),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:social_book/app/components/common_network_image.dart';
// import 'package:social_book/app/core/config/theme/app_colors.dart';
// import 'package:social_book/app/data/models/story/story_model.dart';
// import 'package:social_book/app/modules/home/social/controllers/social_controller.dart';
// import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
// import 'package:video_player/video_player.dart';
// import '../controllers/story_controller.dart';

// class StoryView extends GetView<StoryController> {
//   const StoryView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
// controller.fetchMyStory();
//     if (!Get.isRegistered<StoryController>()) {
//       Get.put(StoryController());
//     }

//     return Obx(() {
//       if (controller.isLoading.value) {
//         return _buildLoadingState(isDark);
//       }

//       return Container(
//         height: 110.h,
//         color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//         padding: EdgeInsets.symmetric(vertical: 8.h),
//         child: ListView.builder(
//           physics: const BouncingScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.symmetric(horizontal: 12.w),
//           itemCount: controller.userIds.length + 1,
//           itemBuilder: (context, index) {
//             if (index == 0) {
//               return _buildMyStoryItem(context, isDark);
//             }

//             final storyIndex = index - 1;
//             final story = controller.getStoryForUser(storyIndex);
//             if (story == null) return const SizedBox.shrink();

//             return GestureDetector(
//               onTap: () {
//                 controller.openStoryAtIndex(storyIndex);
//                 Navigator.push(
//                   context,
//                   PageRouteBuilder(
//                     pageBuilder:
//                         (context, animation, secondaryAnimation) =>
//                             const StoryViewerScreen(),
//                     transitionsBuilder: (
//                       context,
//                       animation,
//                       secondaryAnimation,
//                       child,
//                     ) {
//                       const begin = Offset(1.0, 0.0);
//                       const end = Offset.zero;
//                       const curve = Curves.easeInOut;
//                       var tween = Tween(
//                         begin: begin,
//                         end: end,
//                       ).chain(CurveTween(curve: curve));
//                       return SlideTransition(
//                         position: animation.drive(tween),
//                         child: child,
//                       );
//                     },
//                     transitionDuration: const Duration(milliseconds: 300),
//                   ),
//                 );
//               },
//               child: _buildStoryItem(context, isDark, story, storyIndex),
//             );
//           },
//         ),
//       );
//     });
//   }

//   Widget _buildMyStoryItem(BuildContext context, bool isDark) {
//     final profileController =
//         Get.isRegistered<ProfileController>()
//             ? Get.find<ProfileController>()
//             : Get.put(ProfileController());
//     final String userImg =
//         profileController.userProfileModel.value?.data?.profilePictureUrl ?? "";
//     final bool hasMyStory = controller.hasMyStory();

//     return Padding(
//       padding: EdgeInsets.only(right: 12.w),
//       child: GestureDetector(
//         onTap: () {
//           if(controller.myStoryModel.value?.myPostData?.isEmpty??true){
//             if (hasMyStory) {
//             controller.openMyStory();
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const StoryViewerScreen()),
//             );
//           } else {
//             final socialController = Get.put(SocialController());
//             socialController.pickImages();
//           }
//           }else{
//             Get.to(StoryViewerScreen());
//           }
         
//         },
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 Container(
//                   width: 68.w,
//                   height: 68.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient:
//                         hasMyStory
//                             ? LinearGradient(
//                               colors: [
//                                 AppColors.primaryColor,
//                                 AppColors.secondaryPrimary,
//                               ],
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                             )
//                             : null,
//                     border:
//                         !hasMyStory
//                             ? Border.all(
//                               color:
//                                   isDark
//                                       ? Colors.grey.shade700
//                                       : Colors.grey.shade300,
//                               width: 2,
//                             )
//                             : null,
//                   ),
//                   padding: const EdgeInsets.all(3),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           isDark
//                               ? AppColors.darkSurface
//                               : AppColors.lightSurface,
//                     ),
//                     padding: const EdgeInsets.all(2),
//                     child: ClipOval(
//                       child:
//                           userImg.isNotEmpty
//                               ? CommonNetworkImage(
//                                 imageUrl: userImg,
//                                 width: 68.w,
//                                 height: 68.w,
//                                 fit: BoxFit.cover,
//                                 borderRadius: BorderRadius.zero,
//                               )
//                               : Container(
//                                 color: AppColors.primaryColor.withValues(
//                                   alpha: 0.1,
//                                 ),
//                                 child: Icon(
//                                   Icons.person,
//                                   color: AppColors.primaryColor,
//                                   size: 32.sp,
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ),
//                 if (!hasMyStory)
//                   Positioned(
//                     bottom: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.all(2),
//                       decoration: BoxDecoration(
//                         color: isDark ? AppColors.darkSurface : Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Container(
//                         width: 20.w,
//                         height: 20.w,
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryColor,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.add,
//                           size: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//             SizedBox(height: 6.h),
//             Text(
//               hasMyStory ? 'Your Story' : 'Add Story',
//               style: TextStyle(
//                 color: isDark ? Colors.white : Colors.black87,
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w400,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStoryItem(
//     BuildContext context,
//     bool isDark,
//     StoryData story,
//     int index,
//   ) {
//     final bool isViewed = controller.isStoryViewed(story.userId ?? 0);

//     return Padding(
//       padding: EdgeInsets.only(right: 12.w),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 68.w,
//             height: 68.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient:
//                   !isViewed
//                       ? LinearGradient(
//                         colors: [
//                           AppColors.primaryColor,
//                           AppColors.secondaryPrimary,
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                       : null,
//               border:
//                   isViewed
//                       ? Border.all(color: Colors.grey.shade400, width: 2)
//                       : null,
//             ),
//             padding: const EdgeInsets.all(3),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//               ),
//               padding: const EdgeInsets.all(2),
//               child: ClipOval(
//                 child: CommonNetworkImage(
//                   imageUrl: story.profilePicture ?? '',
//                   width: 68.w,
//                   height: 68.w,
//                   fit: BoxFit.cover,
//                   borderRadius: BorderRadius.zero,
//                   errorWidget: Container(
//                     color: AppColors.primaryColor.withValues(alpha: 0.1),
//                     child: Center(
//                       child: Text(
//                         story.displayName?.isNotEmpty == true
//                             ? story.displayName![0].toUpperCase()
//                             : 'U',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 24.sp,
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 6.h),
//           SizedBox(
//             width: 68.w,
//             child: Text(
//               story.displayName ?? 'User',
//               style: TextStyle(
//                 color: isDark ? Colors.white : Colors.black87,
//                 fontSize: 12.sp,
//                 fontWeight: FontWeight.w400,
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState(bool isDark) {
//     return Container(
//       height: 110.h,
//       alignment: Alignment.center,
//       color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
//       child: const CircularProgressIndicator(strokeWidth: 2),
//     );
//   }
// }

// // ==================== STORY VIEWER SCREEN ====================
// class StoryViewerScreen extends StatefulWidget {
//   const StoryViewerScreen({super.key});

//   @override
//   State<StoryViewerScreen> createState() => _StoryViewerScreenState();
// }

// class _StoryViewerScreenState extends State<StoryViewerScreen>
//     with SingleTickerProviderStateMixin {
//   final controller = Get.find<StoryController>();
//   late AnimationController _animationController;
//   final TextEditingController _replyController = TextEditingController();
//   final FocusNode _replyFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(vsync: this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.startStoryTimer();
//       controller.markCurrentStoryAsViewed();
//     });

//     _replyFocusNode.addListener(() {
//       if (_replyFocusNode.hasFocus) {
//         controller.pauseStory();
//       } else {
//         controller.resumeStory();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller.pauseStory();
//     _animationController.dispose();
//     _replyController.dispose();
//     _replyFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Colors.black,
//       resizeToAvoidBottomInset: true,
//       body: Obx(() {
//         final story = controller.getCurrentStory();

//         if (story == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return GestureDetector(
//           onTapUp: (details) {
//             if (!_replyFocusNode.hasFocus) {
//               controller.onStoryTap(details, screenWidth);
//             }
//           },
//           onLongPressStart: (_) => controller.onLongPressStart(),
//           onLongPressEnd: (_) => controller.onLongPressEnd(),
//           onVerticalDragEnd: (details) {
//             if (details.primaryVelocity! > 300) {
//               Get.back();
//             }
//           },
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // 1. MEDIA CONTENT
//               _buildMediaContent(story),

//               // 2. TOP GRADIENT
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 150.h,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.8),
//                         Colors.black.withOpacity(0.4),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // 3. BOTTOM GRADIENT
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   height: 150.h,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                       colors: [
//                         AppColors.black.withOpacity(0.7),
//                         AppColors.black.withOpacity(0.3),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               // 4. PROGRESS BARS
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 8.h,
//                 left: 8.w,
//                 right: 8.w,
//                 child: _buildProgressBars(),
//               ),

//               // 5. USER HEADER
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 25.h,
//                 left: 12.w,
//                 right: 60.w,
//                 child: _buildUserHeader(story),
//               ),

//               // 6. CLOSE BUTTON
//               Positioned(
//                 top: MediaQuery.of(context).padding.top + 20.h,
//                 right: 8.w,
//                 child: IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white, size: 28),
//                   onPressed: () => Get.back(),
//                 ),
//               ),

//               // 7. REPLY INPUT
//               Positioned(
//                 bottom: MediaQuery.of(context).padding.bottom + 10.h,
//                 left: 12.w,
//                 right: 12.w,
//                 child: _buildReplyInput(isDark),
//               ),

//               // 8. STORY ACTIONS
//               Positioned(
//                 bottom: MediaQuery.of(context).padding.bottom + 70.h,
//                 right: 12.w,
//                 child: _buildStoryActions(),
//               ),

//               // 9. VIEW COUNT (if my story)
//               if (controller.isMyStory())
//                 Positioned(
//                   bottom: MediaQuery.of(context).padding.bottom + 70.h,
//                   left: 12.w,
//                   child: _buildViewCount(),
//                 ),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildMediaContent(story) {
//     final mediaUrl =
//         (story.media != null && story.media!.isNotEmpty)
//             ? story.media!.first.url
//             : "";

//     if (controller.isVideo(story)) {
//       return VideoStoryPlayer(
//         key: ValueKey(mediaUrl),
//         videoUrl: mediaUrl ?? "",
//         onVideoEnd: () => controller.nextStory(),
//         isMuted: controller.isMuted.value,
//       );
//     } else {
//       return CommonNetworkImage(
//         imageUrl: mediaUrl ?? "",
//         fit: BoxFit.contain,
//         width: double.infinity,
//         height: double.infinity,
//         backgroundColor: Colors.black,
//         borderRadius: BorderRadius.zero,
//         errorWidget: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.broken_image, size: 60.sp, color: Colors.white54),
//               SizedBox(height: 10.h),
//               Text(
//                 'Failed to load story',
//                 style: TextStyle(color: Colors.white54, fontSize: 14.sp),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildProgressBars() {
//     final stories = controller.getCurrentUserStories();
//     if (stories == null || stories.isEmpty) return const SizedBox.shrink();

//     return Row(
//       children: List.generate(stories.length, (index) {
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 2.w),
//             child: Obx(() {
//               double progress = 0.0;
//               if (index < controller.currentStoryIndex.value) {
//                 progress = 1.0;
//               } else if (index == controller.currentStoryIndex.value) {
//                 progress = controller.storyProgress.value;
//               }

//               return ClipRRect(
//                 borderRadius: BorderRadius.circular(2.r),
//                 child: LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.white.withOpacity(0.3),
//                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
//                   minHeight: 3.h,
//                 ),
//               );
//             }),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildUserHeader(story) {
//     final timeAgo = _getTimeAgo(story.createdDate);

//     return Row(
//       children: [
//         Container(
//           width: 36.w,
//           height: 36.w,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.white, width: 2),
//           ),
//           child: ClipOval(
//             child:
//                 story.profilePicture != null
//                     ? CommonNetworkImage(
//                       imageUrl: story.profilePicture!,
//                       width: 36.w,
//                       height: 36.w,
//                       fit: BoxFit.cover,
//                       borderRadius: BorderRadius.zero,
//                     )
//                     : Container(
//                       color: AppColors.primaryColor,
//                       child: const Icon(
//                         Icons.person,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//           ),
//         ),
//         SizedBox(width: 10.w),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 story.displayName ?? 'User',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               Text(
//                 timeAgo,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.8),
//                   fontSize: 12.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         if (!controller.isMyStory())
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Colors.white),
//             onPressed: () => _showStoryOptions(),
//           ),
//       ],
//     );
//   }

//   Widget _buildReplyInput(bool isDark) {
//     if (controller.isMyStory()) {
//       return const SizedBox.shrink();
//     }

//     return Row(
//       children: [
//         Expanded(
//           child: Container(
//             height: 44.h,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white, width: 1.5),
//               borderRadius: BorderRadius.circular(22.r),
//             ),
//             child: TextField(
//               controller: _replyController,
//               focusNode: _replyFocusNode,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 hintText: 'Send message',
//                 hintStyle: TextStyle(
//                   color: Colors.white.withOpacity(0.6),
//                   fontSize: 14.sp,
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 12.h,
//                 ),
//                 suffixIcon:
//                     _replyController.text.isNotEmpty
//                         ? IconButton(
//                           icon: const Icon(Icons.send, color: Colors.white),
//                           onPressed: () => _sendReply(),
//                         )
//                         : null,
//               ),
//               onChanged: (text) {
//                 setState(() {});
//               },
//               onSubmitted: (text) => _sendReply(),
//             ),
//           ),
//         ),
//         SizedBox(width: 8.w),
//         GestureDetector(
//           onTap: () {
//             controller.likeStory();
//             _showLikeAnimation();
//           },
//           child: Container(
//             width: 44.w,
//             height: 44.w,
//             decoration: const BoxDecoration(shape: BoxShape.circle),
//             child: const Icon(
//               Icons.favorite_border,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),
//         ),
//         SizedBox(width: 4.w),
//         GestureDetector(
//           onTap: () => controller.shareStory(),
//           child: Container(
//             width: 44.w,
//             height: 44.w,
//             decoration: const BoxDecoration(shape: BoxShape.circle),
//             child: Transform.rotate(
//               angle: -0.5,
//               child: const Icon(Icons.send, color: Colors.white, size: 24),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStoryActions() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Obx(
//           () => IconButton(
//             icon: Icon(
//               controller.isMuted.value ? Icons.volume_off : Icons.volume_up,
//               color: Colors.white,
//               size: 28,
//             ),
//             onPressed: () => controller.toggleMute(),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildViewCount() {
//     return Obx(() {
//       final viewCount = controller.currentStoryViewCount.value;
//       return GestureDetector(
//         onTap: () => _showViewersList(),
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//           decoration: BoxDecoration(
//             color: Colors.black.withOpacity(0.5),
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(Icons.visibility, color: Colors.white, size: 18),
//               SizedBox(width: 4.w),
//               Text(
//                 '$viewCount',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   void _sendReply() {
//     if (_replyController.text.trim().isNotEmpty) {
//       controller.sendReply(_replyController.text.trim());
//       _replyController.clear();
//       _replyFocusNode.unfocus();
//       Get.snackbar(
//         'Sent',
//         'Your reply has been sent',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.white.withOpacity(0.2),
//         colorText: Colors.white,
//         margin: EdgeInsets.all(10.w),
//       );
//     }
//   }

//   void _showLikeAnimation() {
//     Get.snackbar(
//       '',
//       '',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: const Duration(milliseconds: 800),
//       backgroundColor: Colors.transparent,
//       messageText: const Icon(Icons.favorite, color: Colors.red, size: 80),
//       margin: EdgeInsets.zero,
//     );
//   }

//   void _showViewersList() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => Container(
//             height: 400.h,
//             decoration: BoxDecoration(
//               color:
//                   Theme.of(context).brightness == Brightness.dark
//                       ? const Color(0xFF1C1C1E)
//                       : Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//             ),
//             child: Column(
//               children: [
//                 SizedBox(height: 12.h),
//                 Container(
//                   width: 40.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//                 SizedBox(height: 16.h),
//                 Text(
//                   'Viewers',
//                   style: TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Divider(height: 20.h),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: 10,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: AppColors.primaryColor,
//                           child: Text('U${index + 1}'),
//                         ),
//                         title: Text('User ${index + 1}'),
//                         subtitle: Text('2h ago'),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//     );
//   }

//   String _getTimeAgo(String? dateStr) {
//     if (dateStr == null) return 'Just now';

//     try {
//       final date = DateTime.parse(dateStr);
//       final now = DateTime.now();
//       final difference = now.difference(date);

//       if (difference.inSeconds < 60) {
//         return 'Just now';
//       } else if (difference.inMinutes < 60) {
//         return '${difference.inMinutes}m';
//       } else if (difference.inHours < 24) {
//         return '${difference.inHours}h';
//       } else {
//         return '${difference.inDays}d';
//       }
//     } catch (e) {
//       return 'Just now';
//     }
//   }

//   void _showStoryOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder:
//           (context) => Container(
//             decoration: BoxDecoration(
//               color:
//                   Theme.of(context).brightness == Brightness.dark
//                       ? const Color(0xFF1C1C1E)
//                       : Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 12.h),
//                 Container(
//                   width: 40.w,
//                   height: 4.h,
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: BorderRadius.circular(2.r),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 ListTile(
//                   leading: const Icon(Icons.report_outlined, color: Colors.red),
//                   title: const Text('Report'),
//                   onTap: () {
//                     Get.back();
//                     controller.reportStory();
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.block_outlined),
//                   title: const Text('Block'),
//                   onTap: () {
//                     Get.back();
//                     controller.blockUser();
//                   },
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.volume_off_outlined),
//                   title: const Text('Mute Stories'),
//                   onTap: () {
//                     Get.back();
//                     controller.muteUserStories();
//                   },
//                 ),
//                 SizedBox(height: 20.h),
//               ],
//             ),
//           ),
//     );
//   }
// }

// // ==================== VIDEO PLAYER ====================
// class VideoStoryPlayer extends StatefulWidget {
//   final String videoUrl;
//   final VoidCallback onVideoEnd;
//   final bool isMuted;

//   const VideoStoryPlayer({
//     super.key,
//     required this.videoUrl,
//     required this.onVideoEnd,
//     this.isMuted = false,
//   });

//   @override
//   State<VideoStoryPlayer> createState() => _VideoStoryPlayerState();
// }

// class _VideoStoryPlayerState extends State<VideoStoryPlayer> {
//   late VideoPlayerController _vController;
//   bool _isInitialized = false;
//   bool _hasError = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   @override
//   void didUpdateWidget(VideoStoryPlayer oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.isMuted != widget.isMuted) {
//       _vController.setVolume(widget.isMuted ? 0 : 1);
//     }
//   }

//   void _initializeVideo() {
//     if (widget.videoUrl.isEmpty) {
//       setState(() => _hasError = true);
//       return;
//     }

//     _vController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
//       ..initialize()
//           .then((_) {
//             if (mounted) {
//               setState(() => _isInitialized = true);
//               _vController.play();
//               _vController.setLooping(false);
//               _vController.setVolume(widget.isMuted ? 0 : 1);

//               _vController.addListener(() {
//                 if (_vController.value.position >=
//                     _vController.value.duration) {
//                   widget.onVideoEnd();
//                 }
//               });
//             }
//           })
//           .catchError((error) {
//             debugPrint("Video initialization error: $error");
//             if (mounted) {
//               setState(() => _hasError = true);
//             }
//           });
//   }

//   @override
//   void dispose() {
//     _vController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 60.sp, color: Colors.white54),
//             SizedBox(height: 10.h),
//             Text(
//               'Failed to load video',
//               style: TextStyle(color: Colors.white54, fontSize: 14.sp),
//             ),
//           ],
//         ),
//       );
//     }

//     if (!_isInitialized) {
//       return const Center(
//         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//       );
//     }

//     return Center(
//       child: AspectRatio(
//         aspectRatio: _vController.value.aspectRatio,
//         child: VideoPlayer(_vController),
//       ),
//     );
//   }
// }



