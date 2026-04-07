import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/enums/riend_status.dart';
import 'package:social_book/app/data/models/friends/friend_request_model.dart';
import 'package:social_book/app/modules/addFriends/controllers/add_friends_controller.dart';

class FriendsRequestUi extends StatelessWidget {
  final FriendRequest? friendRequest;
  final bool? sendRequestType;
  final int? index;
  const FriendsRequestUi({
    super.key,
    this.friendRequest,
    this.sendRequestType,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<AddFriendsController>(
      init: AddFriendsController(),
      builder: (controller) {
        return Container(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Stack(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                      ),
                    ),
                    child:
                        friendRequest?.profilePicture != null
                            ? ClipOval(
                              child: Image.network(
                                friendRequest?.profilePicture ?? "",
                                fit: BoxFit.cover,
                                width: 40.sp,
                                height: 40.sp,
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;

                                  return Center(
                                    child: SizedBox(
                                      width: 20.sp,
                                      height: 20.sp,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person_rounded,
                                    size: 40.sp,
                                    color: AppColors.white,
                                  );
                                },
                              ),
                            )
                            : Icon(
                              Icons.person_rounded,
                              size: 40.sp,
                              color: AppColors.white,
                            ),
                  ),
                  // if (friend['isOnline'] == true)
                  // Positioned(
                  //   bottom: 2,
                  //   right: 2,
                  //   child: Container(
                  //     width: 16.w,
                  //     height: 16.h,
                  //     decoration: BoxDecoration(
                  //       color: AppColors.green,
                  //       shape: BoxShape.circle,
                  //       border: Border.all(
                  //         color: isDark ? AppColors.darkSurface : AppColors.white,
                  //         width: 2,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              SizedBox(width: 12.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friendRequest?.displayName ?? "",
                      style: AppTextStyles.subtitle().copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    // if (friend['mutualFriends'] != null &&
                    //     friend['mutualFriends'] > 0)
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(
                          Icons.people_rounded,
                          size: 14.sp,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '6 mutual friends',
                          style: AppTextStyles.caption().copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),

                    // if (!isSuggestion && friend['requestTime'] != null)
                    SizedBox(height: 5.h),
                    // Action Buttons
                    sendRequestType == true
                        ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                () => {
                                  controller.rejectFriendRequest(
                                    friendID: friendRequest?.friendId,
                                  ),
                                },

                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isDark
                                      ? AppColors.darkSurface
                                      : AppColors.darkTextPrimary,
                              foregroundColor: AppColors.white,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                side: BorderSide(color: AppColors.darkDivider),
                              ),
                            ),
                            child: Text(
                              'Cencel Request',
                              style: AppTextStyles.body().copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    isDark
                                        ? AppColors.white
                                        : AppColors.darkBackground,
                              ),
                            ),
                          ),
                        )
                        : friendRequest?.state == "pending"
                        ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {},
                            // isSuggestion
                            //     ? controller.sendFriendRequest(friend['id'])
                            //     : controller.acceptFriendRequest(
                            //       friend['id'],
                            //     ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isDark
                                      ? AppColors.darkSurface
                                      : AppColors.darkTextPrimary,
                              foregroundColor: AppColors.white,
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                side: BorderSide(color: AppColors.darkDivider),
                              ),
                            ),
                            child: Text(
                              'Friend',
                              style: AppTextStyles.body().copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    isDark
                                        ? AppColors.white
                                        : AppColors.darkBackground,
                              ),
                            ),
                          ),
                        )
                        : buildFriendAction(
                          friendRequest: friendRequest,
                          isDark: isDark,
                          index: index ?? 0,
                          controller: controller,
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildFriendAction({
    required FriendRequest? friendRequest,
    required int index,
    required bool isDark,
    required AddFriendsController controller,
  }) {
    /// 1️⃣ Already Friends
    if (friendRequest?.confirmRequestLoader == true) {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              "Friends",
              style: AppTextStyles.body().copyWith(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    /// 2️⃣ Request Cancelled / Rejected
    if (friendRequest?.cancelRequest == true) {
      return Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              "Request Cancelled",
              style: AppTextStyles.body().copyWith(
                color: AppColors.lightTextSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    }

    /// 3️⃣ Default → Confirm / Cancel Buttons
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              controller.setStatus(FriendStatus.accepted);
              controller.acceptRejectFriendRequest(
                index: index,
                friendID: friendRequest?.friendId,
                type: "FriendRequest",
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Confirm",
              style: AppTextStyles.body().copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              controller.setStatus(FriendStatus.rejected);
              controller.acceptRejectFriendRequest(
                index: index,
                friendID: friendRequest?.friendId,
                type: "cancelRequest",
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              side: BorderSide(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.body().copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
