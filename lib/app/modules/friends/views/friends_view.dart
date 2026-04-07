import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/friends_controller.dart';


class FriendsView extends GetView<FriendsController> {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightBackground,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? AppColors.lightBackground : AppColors.darkBackground,),
        
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: Text(
          'Friends',
          style: AppTextStyles.headlineMedium(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // Search functionality
            },
            icon: Icon(
              Icons.search,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      body: Obx(() {
        final friendModel = controller.friendModel.value;
        final friends = friendModel?.data ?? [];
        final isLoading = controller.isLoading.value;

        if (friendModel == null && !isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          );
        }

        if (friends.isEmpty && !isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80.sp,
                  color: AppColors.lightTextSecondary,
                ),
                SizedBox(height: 16.h),
                Text(
                  'No friends yet',
                  style: AppTextStyles.headlineMedium(),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Start adding friends to see them here',
                  style: AppTextStyles.caption(),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Friends count header
            // Container(
            //   width: double.infinity,
            //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            //   color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            //   child: Row(
            //     children: [
            //       Text(
            //         '${friendModel?.pagination?.totalRecords ?? 0} Friends',
            //         style: AppTextStyles.subtitle(),
            //       ),
            //       const Spacer(),
            //       TextButton.icon(
            //         onPressed: () {
            //           // Sort functionality
            //         },
            //         icon: Icon(
            //           Icons.sort,
            //           size: 18.sp,
            //           color: AppColors.primaryColor,
            //         ),
            //         label: Text(
            //           'Sort',
            //           style: TextStyle(
            //             color: AppColors.primaryColor,
            //             fontSize: 14.sp,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //   height: 1,
            //   color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            // ),

            // Friends list
            Expanded(
              child: ListView.separated(
                controller: controller.scrollController,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: friends.length + (isLoading ? 1 : 0),
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  // indent: 40.w,
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
                itemBuilder: (context, index) {
                  if (index == friends.length) {
                    return Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    );
                  }

                  final friend = friends[index];
                  return _buildFriendTile(context, friend, isDark);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFriendTile(BuildContext context, dynamic friend, bool isDark) {
    return InkWell(
      onTap: () {
        // Navigate to friend's profile
      },
      child: Container(
      
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Profile picture
            Stack(
              children: [
                CircleAvatar(
                  radius: 32.r,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  backgroundImage: friend.profilePicture != null && 
                                   friend.profilePicture!.isNotEmpty
                      ? NetworkImage(friend.profilePicture!)
                      : null,
                  child: friend.profilePicture == null || 
                         friend.profilePicture!.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 32.sp,
                          color: AppColors.primaryColor,
                        )
                      : null,
                ),
                // Online indicator (optional)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),

            // Friend info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.displayName ?? 'Unknown',
                    style: AppTextStyles.headlineMedium().copyWith(
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (friend.city != null && friend.city!.isNotEmpty) ...[
                        Icon(
                          Icons.location_on,
                          size: 14.sp,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            '${friend.city}${friend.state != null ? ", ${friend.state}" : ""}',
                            style: AppTextStyles.caption().copyWith(
                              fontSize: 13.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (friend.requestDate != null) ...[
                    SizedBox(height: 2.h),
                    Text(
                      'Friends since ${_formatDate(friend.requestDate)}',
                      style: AppTextStyles.small().copyWith(
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Action button
            PopupMenuButton(
              icon: Icon(
                Icons.more_horiz,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.message_outlined,
                        size: 20.sp,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Message',
                        style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Message functionality
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 20.sp,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'View Profile',
                        style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  onTap: () {
                    // View profile functionality
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_remove_outlined,
                        size: 20.sp,
                        color: AppColors.red,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Unfriend',
                        style: AppTextStyles.body().copyWith(
                          fontSize: 14.sp,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Unfriend functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? "month" : "months"} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? "year" : "years"} ago';
    }
  }
}