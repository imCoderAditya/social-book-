import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/circle_image_view.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/core/utils/share_utils.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/modules/home/comment/controllers/comment_controller.dart';
import 'package:social_book/app/modules/home/comment/views/comment_view.dart';
import 'package:social_book/app/modules/home/components/new_post_view.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';

import 'package:social_book/app/modules/home/widget/post_media_carousel.dart';

class SocialView extends GetView<HomeController> {
  const SocialView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
  
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return Column(
          children: [
            CreatePostUI(),
            Divider(
              height: height * 0.015,
              thickness: height * 0.01,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),

            // Posts Feed
            ListView.builder(
              shrinkWrap: true,
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
            ),
          ],
        );
      },
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

    final commentController = Get.isRegistered<CommentController>()?Get.find<CommentController>():Get.put(CommentController());
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
                        postData?.displayName ?? "",
                        style: AppTextStyles.body().copyWith(
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
                            style: AppTextStyles.body().copyWith(
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                              fontSize: height * 0.015,
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                          Icon(
                            Icons.public,
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
              style: AppTextStyles.body().copyWith(
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
                postData?.totalLikes == 0
                    ? SizedBox()
                    : Row(
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
                          postData?.totalLikes.toString() ?? "",
                          style: AppTextStyles.body().copyWith(
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
                  style: AppTextStyles.body().copyWith(
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
                Obx(() {
                  controller.isLoading.value;
                  return _buildPostButton(
                    onTap: () => controller.toggleLike(index),
                    isDark: isDark,
                    height: height,
                    width: width,
                    icon:
                        postData?.myReactionType == "Like"
                            ? Icons.thumb_up_rounded
                            : Icons.thumb_up_outlined,
                    label: 'Like',
                    color:
                        postData?.myReactionType == "Like"
                            ? AppColors.primaryColor
                            : null,
                  );
                }),
                _buildPostButton(
                  onTap: () async{
                    showCommentsSheet(context,postData:postData);
                    await commentController.fetchComments(
                      postId:postData?.postId,
                      profileId: commentController.profileId
                    );
                  },
                  isDark: isDark,
                  height: height,
                  width: width,
                  icon: Icons.comment_outlined,
                  label: 'Comment',
                ),
                _buildPostButton(
                  isDark: isDark,
                  height: height,
                  width: width,
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    shareNetworkImageWithText(
                      postData?.thumbnailUrl ?? "",
                      postData?.content ?? "",
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton({
    required bool isDark,
    required double height,
    required double width,
    IconData? icon,
    String? label,
    Color? color,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
                  color ??
                  (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              size: height * 0.025,
            ),
            SizedBox(width: width * 0.02),
            Text(
              label ?? "",
              style: AppTextStyles.body().copyWith(
                color:
                    color ??
                    (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
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
