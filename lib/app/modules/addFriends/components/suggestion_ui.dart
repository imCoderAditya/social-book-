import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/friends/add_friend_model.dart';
import 'package:social_book/app/modules/addFriends/controllers/add_friends_controller.dart';

class SuggestionUi extends StatelessWidget {
  final AddFriends? addFriends;
  final int index;
  const SuggestionUi({super.key, this.addFriends, required this.index});

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
                        addFriends?.profilePicture != null
                            ? ClipOval(
                              child: Image.network(
                                addFriends?.profilePicture ?? "",
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
                      addFriends?.displayName ?? "",
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
                    addFriends?.isSendRequest == true
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
                              'Cancel Request',
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
                        : Row(
                          children: [
                            // Expanded(
                            //   child: ElevatedButton(
                            //     onPressed: () async {
                            //       await controller.sendFriendRequest(
                            //         index: index,
                            //         receiverProfileID: addFriends?.profileId,
                            //         receiverUserID: addFriends?.userId,
                            //       );
                            //     },

                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: AppColors.primaryColor,
                            //       foregroundColor: AppColors.white,
                            //       padding: EdgeInsets.symmetric(vertical: 10.h),
                            //       elevation: 0,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(8.r),
                            //       ),
                            //     ),
                            //     child: Obx(
                            //       () =>
                            //           controller
                            //                       .addFriendsList[index]
                            //                       .sendRequestLoader ??
                            //                   false
                            //               ? Transform.scale(
                            //                 scale: 0.6,
                            //                 child: CircularProgressIndicator(
                            //                   color: AppColors.white,
                            //                 ),
                            //               )
                            //               : Text(
                            //                 'Add Friend',
                            //                 style: AppTextStyles.body()
                            //                     .copyWith(
                            //                       fontSize: 14.sp,
                            //                       fontWeight: FontWeight.w600,
                            //                       color: AppColors.white,
                            //                     ),
                            //               ),
                            //     ),
                            //   ),
                            // ),
                            Expanded(
                              child: Obx(() {
                                final isLoading =
                                    controller
                                        .addFriendsList[index]
                                        .sendRequestLoader ??
                                    false;

                                return ElevatedButton(
                                  onPressed:
                                      isLoading
                                          ? null
                                          : () {
                                            controller.sendFriendRequest(
                                              index: index,
                                              receiverProfileID:
                                                  addFriends?.profileId,
                                              receiverUserID:
                                                  addFriends?.userId,
                                            );
                                          },

                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isLoading
                                            ? AppColors.primaryColor
                                                .withOpacity(0.5)
                                            : AppColors.primaryColor,
                                    foregroundColor: AppColors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),

                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 250),
                                    child:
                                        isLoading
                                            ? SizedBox(
                                              height: 18,
                                              width: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primaryColor,
                                              ),
                                            )
                                            : Text(
                                              'Add Friend',
                                              style: AppTextStyles.body()
                                                  .copyWith(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.white,
                                                  ),
                                              key: ValueKey('AddText'),
                                            ),
                                  ),
                                );
                              }),
                            ),

                            SizedBox(width: 8.w),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => {},
                                // isSuggestion
                                //     ? controller.removeSuggestion(friend['id'])
                                //     : controller.rejectFriendRequest(
                                //       friend['id'],
                                //     ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  side: BorderSide(
                                    color:
                                        isDark
                                            ? AppColors.darkDivider
                                            : AppColors.lightDivider,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                                child: Text(
                                  'Remove',
                                  style: AppTextStyles.body().copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
}
