import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/modules/addFriends/components/friends_request_ui.dart';
import 'package:social_book/app/modules/addFriends/components/suggestion_ui.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/add_friends_controller.dart';

class AddFriendsView extends GetView<AddFriendsController> {
  const AddFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Add Friends', style: AppTextStyles.headlineMedium()),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(
            height: 1.h,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: controller.searchController,
                style: AppTextStyles.body().copyWith(fontSize: 14.sp),

                decoration: InputDecoration(
                  hintText: 'Search friends...',
                  hintStyle: AppTextStyles.caption(),

                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    size: 22.sp,
                  ),
                  suffixIcon:
                      controller.searchController.text.isNotEmpty
                          ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              controller.searchController.clear();
                              controller.searchFriends('');
                            },
                          )
                          : const SizedBox.shrink(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onChanged: controller.searchFriends,
              ),
            ),
          ),

          // Tabs
          Container(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            child: Row(
              children: [
                _buildTab('Suggestions', 0, isDark),
                _buildTab('Friend Requests', 1, isDark),
                _buildTab('Send Requests', 2, isDark),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _buildSuggestionsList(isDark);
              } else if (controller.selectedTab.value == 1) {
                return _buildFriendRequestsList(isDark);
              } else {
                return _buildSendFriendRequestsList(isDark);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, bool isDark) {
    return Obx(() {
      final isSelected = controller.selectedTab.value == index;
      return Expanded(
        child: GestureDetector(
          onTap:
              () => {
                controller.selectedTab.value = index,
                controller.searchController.clear(),

                if (controller.selectedTab.value == 0)
                  {
                    controller.currentPage.value = 1,
                    controller.addFriendsList.clear(),
                    controller.fetchAddFriendData(),
                  }
                else if (controller.selectedTab.value == 1)
                  {
                    controller.friendRequestList.clear(),
                    controller.fetchFriendRequestData(),
                  }
                else
                  {
                    controller.sendFriendRequestList.clear(),
                    controller.fetchSendFriendRequestData(),
                  },
              },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color:
                      isSelected ? AppColors.primaryColor : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.body().copyWith(
                fontSize: 15.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color:
                    isSelected
                        ? AppColors.primaryColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSuggestionsList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value && controller.addFriendsList.isEmpty) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.addFriendsList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: 80.sp,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              SizedBox(height: 16.h),
              Text('No suggestions yet', style: AppTextStyles.subtitle()),
              SizedBox(height: 8.h),
              Text(
                'Check back later for new friend suggestions',
                style: AppTextStyles.caption(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          controller.currentPage.value = 1;
          controller.addFriendsList.clear();
          await controller.fetchAddFriendData();
        },

        child: ListView.separated(
          controller: controller.scrollController,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          itemCount:
              controller.addFriendsList.length +
              (controller.isLoading.value ? 1 : 0),
          separatorBuilder:
              (context, index) => Divider(
                height: 1.h,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),

          itemBuilder: (context, index) {
            if (index < controller.addFriendsList.length) {
              final friend = controller.addFriendsList[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.PROFILE_OTHER_USER,
                    arguments: {"profileId": friend.profileId ?? 0},
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: SuggestionUi(addFriends: friend, index: index),
                ),
              );
            } else {
              // Pagination loading indicator
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.orange : AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      );
    });
  }

  Widget _buildFriendRequestsList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.friendRequestList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled_rounded,
                size: 80.sp,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              SizedBox(height: 16.h),
              Text('No friend requests', style: AppTextStyles.subtitle()),
              SizedBox(height: 8.h),
              Text(
                'When people send you requests, they\'ll appear here',
                style: AppTextStyles.caption(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: controller.friendRequestList.length,
        separatorBuilder:
            (context, index) => Divider(
              height: 1.h,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
        itemBuilder: (context, index) {
          final friend = controller.friendRequestList[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                Routes.PROFILE_OTHER_USER,
                arguments: {"profileId": friend.senderProfileId ?? 0},
              );
            },
            child: FriendsRequestUi(friendRequest: friend, index: index),
          );
        },
      );
    });
  }

  Widget _buildSendFriendRequestsList(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        );
      }

      if (controller.sendFriendRequestList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled_rounded,
                size: 80.sp,
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
              SizedBox(height: 16.h),
              Text('No friend requests', style: AppTextStyles.subtitle()),
              SizedBox(height: 8.h),
              Text(
                'When people send you requests, they\'ll appear here',
                style: AppTextStyles.caption(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: controller.sendFriendRequestList.length,
        separatorBuilder:
            (context, index) => Divider(
              height: 1.h,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
        itemBuilder: (context, index) {
          final friend = controller.sendFriendRequestList[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                Routes.PROFILE_OTHER_USER,
                arguments: {"profileId": friend.receiverProfileId ?? 0},
              );
            },
            child: FriendsRequestUi(
              friendRequest: friend,
              sendRequestType: true,
            ),
          );
        },
      );
    });
  }
}
