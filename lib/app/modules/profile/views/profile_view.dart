// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/components/circle_image_view.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/core/widgets/profile_shimmer_effect.dart';
import 'package:social_book/app/data/models/post/my_post_model.dart';
import 'package:social_book/app/modules/friends/controllers/friends_controller.dart';
import 'package:social_book/app/modules/home/widget/post_media_carousel.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return Obx(() {
          final userProfile = controller.userProfileModel.value?.data;
          // ⬅ Show shimmer while loading
          if (controller.isLoading.value && userProfile == null) {
            return ProfileShimmer(isDark: isDark);
          }
          return Scaffold(
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            body: CustomScrollView(
              controller: controller.myPostScrollController,
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                // Cover Photo & Profile Header
                SliverAppBar(
                  expandedHeight: 280.h,
                  pinned: true,
                  backgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.5,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Cover Photo
                        Container(
                          decoration: BoxDecoration(),
                          child: Image.network(
                            userProfile?.coverImageUrl ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: AppColors.headerGradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.landscape,
                                  size: 80.sp,
                                  color: AppColors.white.withOpacity(0.3),
                                ),
                              );
                            },
                          ),
                        ),

                        // Edit Cover Button
                        Positioned(
                          top: 100.h,
                          right: 8.w,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: AppColors.white,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                controller.imageCoverUpload();
                              },
                            ),
                          ),
                        ),
                        // Profile Picture
                        Positioned(
                          bottom: 20.h,
                          left: 16.w,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isDark
                                            ? AppColors.darkBackground
                                            : AppColors.lightBackground,
                                    width: 4.w,
                                  ),
                                ),
                                child: CircleImageView(
                                  radius: 60.r,
                                  image: userProfile?.profilePictureUrl ?? "",
                                  displayName: userProfile?.displayName ?? "",
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          isDark
                                              ? AppColors.darkBackground
                                              : AppColors.lightBackground,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.white,
                                      size: 18.sp,
                                    ),
                                    onPressed: () {
                                      controller.imageProfileUpload();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: AppColors.white,
                        size: 24.sp,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                // Profile Info & Content
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Name and Bio Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userProfile?.displayName ?? "",
                                        style: AppTextStyles.headlineLarge(),
                                      ),
                                      SizedBox(height: 4.h),
                                      GetBuilder<FriendsController>(
                                        init: FriendsController(),
                                        builder: (controller) {
                                          return Text(
                                            '${controller.friendModel.value?.data?.length ?? 0} friends',
                                            style: AppTextStyles.caption()
                                                .copyWith(
                                                  color:
                                                      isDark
                                                          ? AppColors
                                                              .darkTextSecondary
                                                          : AppColors
                                                              .lightTextSecondary,
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              userProfile?.bio ?? "",
                              style: AppTextStyles.caption(),
                            ),
                            SizedBox(height: 16.h),

                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.add, size: 20.sp),
                                    label: Text(
                                      'Add to Story',
                                      style: AppTextStyles.button.copyWith(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: AppColors.white,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Get.toNamed(
                                        Routes.EDIT_PROFILE,
                                        arguments: userProfile,
                                      )?.then((value) async {
                                        await controller.fetchProfile();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20.sp,
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary,
                                    ),
                                    label: Text(
                                      'Edit Profile',
                                      style: AppTextStyles.caption().copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color:
                                            isDark
                                                ? AppColors.darkDivider
                                                : AppColors.lightDivider,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? AppColors.darkBackground
                                            : AppColors.lightBackground,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color:
                                          isDark
                                              ? AppColors.darkDivider
                                              : AppColors.lightDivider,
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color:
                                          isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Details Section
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: AppTextStyles.headlineMedium(),
                            ),
                            SizedBox(height: 16.h),
                            _buildDetailItem(
                              Icons.work,
                              'Works at',
                              userProfile?.education?.capitalizeFirst ?? "",
                              isDark,
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailItem(
                              Icons.school,
                              'Studied at',
                              userProfile?.profession ?? "",
                              isDark,
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailItem(
                              Icons.home,
                              'Lives in',
                              "${userProfile?.city?.capitalizeFirst ?? ""} ",
                              isDark,
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailItem(
                              Icons.location_on,
                              'From',
                              '${userProfile?.state?.capitalizeFirst ?? ""} ${userProfile?.country?.capitalizeFirst ?? ""}',
                              isDark,
                            ),
                            SizedBox(height: 12.h),
                            _buildDetailItem(
                              Icons.favorite,
                              'Relationship',
                              userProfile?.relationshipStatus ?? "N/A",
                              isDark,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Friends Section
                      GetBuilder<FriendsController>(
                        init: FriendsController(),
                        builder: (controller) {
                          return controller.friendModel.value?.data?.isEmpty ??
                                  false
                              ? SizedBox()
                              : Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color:
                                      isDark
                                          ? AppColors.darkSurface
                                          : AppColors.lightSurface,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Friends',
                                          style: AppTextStyles.headlineMedium(),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.toNamed(Routes.FRIENDS);
                                          },
                                          child: Text(
                                            'See all',
                                            style: AppTextStyles.caption()
                                                .copyWith(
                                                  color: AppColors.primaryColor,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2.h),
                                    Obx(
                                      () => Text(
                                        '${controller.friendModel.value?.data?.length ?? 0} friends',
                                        style: AppTextStyles.caption().copyWith(
                                          color:
                                              isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                      .lightTextSecondary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),

                                    Obx(() {
                                      final friend = (controller
                                                  .friendModel
                                                  .value
                                                  ?.data
                                                  ?.length ??
                                              0)
                                          .clamp(0, 8);

                                      return SizedBox(
                                        height: 180.h,
                                        child: GridView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,

                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 9.w,
                                                childAspectRatio: 2 / (2.5),
                                              ),
                                          itemCount: friend,
                                          itemBuilder: (context, index) {
                                            final friend =
                                                controller
                                                    .friendModel
                                                    .value
                                                    ?.data?[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                  Routes.PROFILE_OTHER_USER,
                                                  arguments: {
                                                    "profileId":
                                                        friend?.profileId ?? 0,
                                                  },
                                                );
                                              },
                                              child: Column(
                                                children: [
                                                  CircleImageView(
                                                    radius: 30.r,
                                                    image:
                                                        friend
                                                            ?.profilePicture ??
                                                        "",
                                                    displayName:
                                                        friend?.displayName ??
                                                        "",
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Text(
                                                    friend?.displayName ?? "",
                                                    style: AppTextStyles.small()
                                                        .copyWith(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                        },
                      ),
                      SizedBox(height: 10.h),
                      // Posts Section
                      controller.myPostList.isEmpty
                          ? SizedBox()
                          : Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            decoration: BoxDecoration(
                              color:
                                  isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.h),
                                Text(
                                  'Posts',
                                  style: AppTextStyles.headlineMedium(),
                                ),
                                SizedBox(height: 10.h),
                                ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.myPostList.length + 1,
                                  separatorBuilder:
                                      (context, index) =>
                                          SizedBox(height: 10.h),
                                  itemBuilder: (context, index) {
                                    if (index < controller.myPostList.length) {
                                      return _buildPostCard(
                                        isDark,
                                        myPostData:
                                            controller.myPostList[index],
                                      );
                                    } else {
                                      return Obx(() {
                                        return controller.isLoading.value
                                            ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 16.h,
                                              ),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            )
                                            : const SizedBox();
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildDetailItem(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
          color:
              isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label ',
                  style: AppTextStyles.caption().copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: AppTextStyles.caption().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostCard(bool isDark, {MyPostData? myPostData}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleImageView(
                image: myPostData?.profilePicture ?? "",
                displayName: myPostData?.displayName ?? "",
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myPostData?.displayName ?? "",
                      style: AppTextStyles.caption().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      AppDateUtils.timeAgo(myPostData?.createdAt ?? "")??"",
                      style: AppTextStyles.small(),
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
          SizedBox(height: 12.h),
          Text(myPostData?.content ?? "", style: AppTextStyles.caption()),
          SizedBox(height: 12.h),
          if (myPostData?.mediaUrl != null && myPostData!.mediaUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: PostMediaCarousel(
                key: ValueKey(
                  'post_${myPostData.rowNum}_media',
                ), // ✅ CRITICAL FIX
                mediaUrls: myPostData.mediaUrl!,
                postType: myPostData.postType ?? "image",
                isDark: isDark,
                height: 180.h,
              ),
            ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPostAction(Icons.thumb_up_outlined, '125', isDark),
              _buildPostAction(Icons.comment_outlined, '45', isDark),
              _buildPostAction(Icons.share_outlined, '12', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostAction(IconData icon, String count, bool isDark) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(
        icon,
        size: 20.sp,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      label: Text(count, style: AppTextStyles.small()),
    );
  }
}
