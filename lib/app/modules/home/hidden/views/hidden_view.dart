import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:social_book/app/components/circle_image_view.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/constant/constants.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/modules/home/components/new_post_view.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';
import 'package:social_book/app/modules/home/widget/post_media_carousel.dart';

import '../controllers/hidden_controller.dart';

class HiddenView extends GetView<HiddenController> {
  const HiddenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // Create Post
        CreatePostUI(),

        Divider(
          height: height * 0.015,
          thickness: height * 0.01,
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),

        // Posts Feed
        // Posts Feed
        GetBuilder<HomeController>(
          init: HomeController(),
          builder: (controller) {
            return ListView.builder(
              shrinkWrap: true,
              // controller: controller.postScrollController,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: controller.postList.length + 1,
              itemBuilder: (context, index) {
                if (index < controller.postList.length) {
                  final postData = controller.postList[index];
                  return _buildPostItem(
                    context,
                    isDark,
                    height,
                    width,
                    index,
                    postData: postData,
                  );
                } else {
                  // 🔽 Bottom Loader
                  return Obx(() {
                    return controller.isLoading.value
                        ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : const SizedBox();
                  });
                }
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildPostItem(
    BuildContext context,
    bool isDark,
    double height,
    double width,
    int index, {
    PostData? postData,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              children: [
                CircleImageView(
                  image: postData?.profilePicture ?? "",
                  displayName: postData?.displayName ?? "",
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maskName(postData?.displayName ?? ""),
                        style: TextStyle(
                          color:
                              isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                          fontSize: height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            AppDateUtils.timeAgo(postData?.createdAt ?? "")??"",
                            style: TextStyle(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                              fontSize: height * 0.015,
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                          Icon(
                            Icons.public_off,
                            size: height * 0.018,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Post Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            child: Text(
              postData?.content ?? "",
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                fontSize: height * 0.018,
              ),
            ),
          ),
          SizedBox(height: height * 0.015),

          // Post Image
          if (postData?.mediaUrl != null && postData!.mediaUrl!.isNotEmpty)
            PostMediaCarousel(
              key: ValueKey(
                'post_${postData.rowNum ?? index}_media',
              ), // ✅ CRITICAL FIX
              mediaUrls: postData.mediaUrl!,
              postType: postData.postType ?? "image",
              isDark: isDark,
              height: 250.h,
            ),
          // Post Stats
          Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.01),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.thumb_up,
                        size: height * 0.018,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: width * 0.01),
                    Text(
                      '${42 + index * 10}',
                      style: TextStyle(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                        fontSize: height * 0.016,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${postData?.commentsCount ?? ""} comments • ${postData?.reactionCounts?.loveCount ?? ""} shares',
                  style: TextStyle(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    fontSize: height * 0.016,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),

          // Post Actions
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPostButton(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.thumb_up_outlined,
                  'Like',
                ),
                _buildPostButton(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.comment_outlined,
                  'Comment',
                ),
                _buildPostButton(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.share_outlined,
                  'Share',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton(
    BuildContext context,
    bool isDark,
    double height,
    double width,
    IconData icon,
    String label,
  ) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: height * 0.01,
          horizontal: width * 0.04,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
              size: height * 0.025,
            ),
            SizedBox(width: width * 0.02),
            Text(
              label,
              style: TextStyle(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                fontSize: height * 0.018,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
