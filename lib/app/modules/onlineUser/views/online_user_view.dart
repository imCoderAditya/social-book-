import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/data/models/onlineUser/online_user_model.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/online_user_controller.dart';

class OnlineUserView extends GetView<OnlineUserController> {
  const OnlineUserView({super.key});

  bool get _isDark => Theme.of(Get.context!).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    log("a${json.encode(controller.filteredUsers)}");
    return GetBuilder<OnlineUserController>(
      init: OnlineUserController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              _isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildActiveStories(),
                // _buildTabBar(),
                Expanded(child: _buildUserList()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color:
                  _isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
              size: 24.sp,
            ),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 8.w),
          Text('Chats', style: AppTextStyles.headlineLarge()),
          const Spacer(),
          // IconButton(
          //   icon: Icon(
          //     Icons.settings_outlined,
          //     color:
          //         _isDark
          //             ? AppColors.darkTextPrimary
          //             : AppColors.lightTextPrimary,
          //     size: 24.sp,
          //   ),
          //   onPressed: () {},
          // ),
          // SizedBox(width: 4.w),
          // IconButton(
          //   icon: Icon(
          //     Icons.edit_outlined,
          //     color:
          //         _isDark
          //             ? AppColors.darkTextPrimary
          //             : AppColors.lightTextPrimary,
          //     size: 24.sp,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color:
                _isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              onChanged: controller.searchUsers,
              style: AppTextStyles.body(),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: AppTextStyles.caption(),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.accentColor,
                  Colors.pink,
                  Colors.orange,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveStories() {
    return Container(
      height: 100.h,
      color: _isDark ? AppColors.darkBackground : AppColors.lightBackground,
      child: Obx(
        () => ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          scrollDirection: Axis.horizontal,
          itemCount: controller.filteredUsers.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildYourNote();
            }
            final user = controller.filteredUsers[index - 1];
            return _buildStoryItem(user);
          },
        ),
      ),
    );
  }

  Widget _buildYourNote() {
    return Container(
      width: 70.w,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isDark ? AppColors.darkDivider : AppColors.lightDivider,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1631947430066-48c30d57b943?q=80&w=716&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      color: AppColors.primaryColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.person,
                        size: 32.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Your note',
            style: AppTextStyles.small(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem(OnlineUser user) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CHAT, arguments: {"userChatData": user}),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(2.w),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: ClipOval(
                      child:
                          user.otherProfilePicture != null
                              ? Image.network(
                                user.otherProfilePicture ?? "",
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      child: Center(
                                        child: Text(
                                          user.otherDisplayName?[0]
                                                  .toUpperCase() ??
                                              "",
                                          style: AppTextStyles.headlineMedium()
                                              .copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                        ),
                                      ),
                                    ),
                              )
                              : Container(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: Center(
                                  child: Text(
                                    user.otherProfilePicture?[0]
                                            .toUpperCase() ??
                                        "",
                                    style: AppTextStyles.headlineMedium()
                                        .copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                  ),
                                ),
                              ),
                    ),
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            _isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              user.otherDisplayName?.split(' ')[0] ?? "",
              style: AppTextStyles.small(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTabBar() {
  //   return Container(
  //     color: _isDark ? AppColors.darkBackground : AppColors.lightBackground,
  //     padding: EdgeInsets.symmetric(horizontal: 16.w),
  //     child: Row(
  //       children: [
  //         _buildTab('Inbox', false),
  //         _buildTab('Unread', true),
  //         _buildTab('Communities', false),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildTab(String title, bool isSelected) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
  //     decoration: BoxDecoration(
  //       color:
  //           isSelected
  //               ? AppColors.primaryColor.withValues(alpha: 0.2)
  //               : Colors.transparent,
  //       borderRadius: BorderRadius.circular(20.r),
  //     ),
  //     child: Text(
  //       title,
  //       style: AppTextStyles.body().copyWith(
  //         color:
  //             isSelected
  //                 ? AppColors.primaryColor
  //                 : (_isDark
  //                     ? AppColors.darkTextSecondary
  //                     : AppColors.lightTextSecondary),
  //         fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
  //         fontSize: 14.sp,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildUserList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.filteredUsers.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        itemCount: controller.filteredUsers.length,
        itemBuilder: (context, index) {
          final user = controller.filteredUsers[index];
          return _buildChatItem(user);
        },
      );
    });
  }

  Widget _buildChatItem(OnlineUser user) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.CHAT, arguments: {"userChatData": user}),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        color: _isDark ? AppColors.darkBackground : AppColors.lightBackground,
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.2,
                  ),
                  backgroundImage:
                      user.otherProfilePicture != null
                          ? NetworkImage(user.otherProfilePicture ?? "")
                          : null,
                  child:
                      user.otherProfilePicture == null
                          ? Text(
                            user.myDisplayName?[0].toUpperCase() ?? "",
                            style: AppTextStyles.headlineMedium().copyWith(
                              color: AppColors.primaryColor,
                            ),
                          )
                          : null,
                ),
                user.myLiveStatus == false
                    ? SizedBox()
                    : Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 14.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                _isDark
                                    ? AppColors.darkBackground
                                    : AppColors.lightBackground,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.otherDisplayName ?? "",
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user.lastMessage ?? 'Active now',
                          style: AppTextStyles.caption().copyWith(
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (user.lastMessageAt != null) ...[
                        Text(
                          AppDateUtils.timeAgo(user.lastMessageAt.toString())??"",
                          style: AppTextStyles.caption().copyWith(
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // if (user.unreadCount != null && user.unreadCount > 0)
            //   Container(
            //     padding: EdgeInsets.all(6.w),
            //     decoration: BoxDecoration(
            //       color: AppColors.primaryColor,
            //       shape: BoxShape.circle,
            //     ),
            //     child: Text(
            //       '${user.unreadCount}',
            //       style: AppTextStyles.small().copyWith(
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80.sp,
            color:
                _isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          SizedBox(height: 16.h),
          Text('No chats yet', style: AppTextStyles.headlineMedium()),
          SizedBox(height: 8.h),
          Text(
            'Start a conversation with someone',
            style: AppTextStyles.caption(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
