// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/components/user_avatar.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/data/models/post/post_model.dart';
import 'package:social_book/app/data/models/reels/reel_comments_model.dart' show Comment;
import 'package:social_book/app/modules/home/comment/controllers/comment_controller.dart';

class CommentView extends GetView<CommentController> {
  final PostData? postData;
  const CommentView({super.key, this.postData});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<CommentController>(
      init: CommentController(),
      builder: (controller) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
          ),
          child: Column(
            children: [
              _buildHeader(isDark),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              Expanded(child: _buildCommentsList(isDark)),
              Divider(
                height: 1,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              _buildCommentInput(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),
            Text('Comments', style: AppTextStyles.headlineMedium()),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentsList(bool isDark) {
    return Obx(() {
      return controller.postCommentModel.value?.data?.comments?.isEmpty ?? true
          ? const Center(
            child: Text(
              "No comments yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount:
                controller.postCommentModel.value?.data?.comments?.length ?? 0,
            itemBuilder: (context, index) {
              final comments =
                  controller.postCommentModel.value?.data?.comments;
              return _buildCommentItem(comments?[index], isDark);
            },
          );
    });
  }

  Widget _buildCommentItem(Comment? comment, bool isDark) {
    return MenuAnchor(
      builder: (context, menuController, child) {
        return GestureDetector(
          onLongPress: () {
            // 👉 long press opens menu
            menuController.open();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  child: CommonNetworkImage(
                    imageUrl: comment?.profilePicture ?? "",
                    borderRadius: BorderRadiusGeometry.circular(100),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: comment?.displayName ?? "",
                              style: AppTextStyles.caption().copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color:
                                    isDark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimaryLight,
                              ),
                            ),
                            TextSpan(
                              text: '  ${comment?.commentText}',
                              style: AppTextStyles.caption().copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Text(
                            AppDateUtils.timeAgo(comment?.createdAt ?? "") ??
                                "",
                            style: AppTextStyles.small(),
                          ),
                          SizedBox(width: 16.w),
                          // if (comment.likes > 0) ...[
                          //   Text(
                          //     '${comment.likes} likes',
                          //     style: AppTextStyles.small().copyWith(
                          //       fontWeight: FontWeight.w600,
                          //     ),
                          //   ),
                          //   SizedBox(width: 16.w),
                          // ],
                          // GestureDetector(
                          //   onTap: () {
                          //     if (comment != null) {
                          //       controller.setReply(comment);
                          //     }
                          //   },
                          //   child: Text(
                          //     'Reply',
                          //     style: AppTextStyles.small().copyWith(
                          //       fontWeight: FontWeight.w600,
                          //       color:
                          //           AppColors.primaryColor, // Highlight color
                          //     ),
                          //   ),
                          // ),
                      
                        ],
                      ),
                    ],
                  ),
                ),
                // Column(
                //   children: [
                //     SizedBox(height: 4.h),
                //     Icon(
                //       comment.isLiked ? Icons.favorite : Icons.favorite_border,
                //       size: 16.r,
                //       color:
                //           comment.isLiked
                //               ? Colors.red
                //               : (isDark
                //                   ? AppColors.darkTextSecondary
                //                   : AppColors.lightTextSecondary),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () async {
            await controller.deleteComment(
              commentID: comment?.commentId,
              postData: postData,
            );
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(
              AppColors.red.withOpacity(0.08),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 16, 10),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Reply Indicator ---
        Obx(() {
          if (controller.replyingToComment.value == null)
            return const SizedBox.shrink();
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            color: isDark ? Colors.grey[900] : Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Replying to ${controller.replyingToComment.value?.displayName}",
                    style: AppTextStyles.small().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.cancelReply(),
                  child: Icon(Icons.close, size: 18.r),
                ),
              ],
            ),
          );
        }),

        // --- Main Input ---
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          ),
          child: SafeArea(
            child: Row(
              children: [
                UserAvatar(),
                SizedBox(width: 12.w),
                Expanded(
                  child: TextField(
                    controller: controller.commentController,
                    focusNode: controller.focusNode,
                    style: AppTextStyles.caption(),
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: AppTextStyles.caption(),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () async {
                            if (controller.commentController.text
                                .trim()
                                .isEmpty)
                              return;

                            FocusScope.of(Get.context!).unfocus();

                            // 🔥 Logic: Agar replyingToComment null nahi hai, toh uska ID pass hoga
                            bool success = await controller.createComments(
                              postId: postData?.postId,
                              parentCommentId:
                                  controller.replyingToComment.value?.commentId,
                              mediaFile: null,
                            );

                            if (success) {
                              controller.cancelReply(); // Reset after post
                            }
                          },
                  child: Obx(
                    () =>
                        controller.isLoading.value
                            ? Transform.scale(
                              scale: 0.6,
                              child: CircularProgressIndicator(),
                            )
                            : Text(
                              'Post',
                              style: AppTextStyles.caption().copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  // Widget _buildCommentInput(bool isDark) {
  //   return GestureDetector(
  //     onTap: () {
  //       MenuItemButton(onPressed: () {}, child: Text("Delete"));
  //     },
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //       decoration: BoxDecoration(
  //         color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
  //       ),
  //       child: SafeArea(
  //         child: Row(
  //           children: [
  //             UserAvatar(),
  //             SizedBox(width: 12.w),
  //             Expanded(
  //               child: TextField(
  //                 controller: controller.commentController,
  //                 focusNode: controller.focusNode,
  //                 style: AppTextStyles.caption(),
  //                 decoration: InputDecoration(
  //                   hintText: 'Add a comment...',
  //                   hintStyle: AppTextStyles.caption(),
  //                   border: InputBorder.none,
  //                   contentPadding: EdgeInsets.zero,
  //                 ),
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () async {
  //                 FocusScope.of(Get.context!).unfocus();
  //                 await controller.createComments(
  //                   postId: postData?.postId,
  //                   parentCommentId: null,
  //                   mediaFile: null,
  //                 );
  //               },
  //               child:
  //                   controller.isLoading.value
  //                       ? Transform.scale(
  //                         scale: 0.6,
  //                         child: CircularProgressIndicator(),
  //                       )
  //                       : Text(
  //                         'Post',
  //                         style: AppTextStyles.caption().copyWith(
  //                           fontWeight: FontWeight.w600,
  //                           color: AppColors.primaryColor,
  //                         ),
  //                       ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// Usage example:
void showCommentsSheet(BuildContext context, {PostData? postData}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // 🔥 REQUIRED
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CommentView(postData: postData),
      );
    },
  );
}
