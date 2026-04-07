import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/modules/auth/profileSelection/controllers/profile_selection_controller.dart';


class ProfileSelectionView extends GetView<ProfileSelectionController> {
  const ProfileSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<ProfileSelectionController>(
      init: ProfileSelectionController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),

                    // Header
                    Column(
                      children: [
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: AppColors.headerGradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 40.sp,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Choose Your Profile Type',
                          style: AppTextStyles.headlineLarge(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Select how you want to present yourself\non Social Book',
                          style: AppTextStyles.caption(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    _buildProfileCard(
                      icon: Icons.groups_rounded,
                      title: 'Social',
                      description:
                          'Build connections and grow your social network',
                      color: const Color(0xFF2196F3),
                      index: 1,
                      isDark: isDark,
                      features: [
                        'Community focus',
                        'Group activities',
                        'Social events',
                      ],
                      
                    ),

                    SizedBox(height: 16.h),

                    _buildProfileCard(
                      icon: Icons.lock_rounded,
                      title: 'Hidden',
                      description:
                          'Stay anonymous while browsing and interacting',
                      color: const Color(0xFF9C27B0),
                      index: 2,
                      isDark: isDark,
                      features: [
                        'Private browsing',
                        'Anonymous mode',
                        'No profile photo',
                      ],
                    ),

                    SizedBox(height: 16.h),

                    _buildProfileCard(
                      icon: Icons.business_center_rounded,
                      title: 'Professional',
                      description:
                          'Showcase your expertise and build business connections',
                      color: const Color(0xFFFF9800),
                      index: 3,
                      isDark: isDark,
                      features: [
                        'Business profile',
                        'Portfolio showcase',
                        'Testimonials',
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Profile Type Cards
                    _buildProfileCard(
                      icon: Icons.meeting_room,
                      title: 'Matrimonial',
                      description:
                          'Share your photo and connect with friends openly',
                      color: const Color(0xFF4CAF50),
                      index: 0,
                      isDark: isDark,
                      features: [
                        'Public visibility',
                        'Photo sharing',
                        'Friend requests',
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Continue Button
                    Obx(
                      () => Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient:
                              controller.selectedType.value != -1
                                  ? LinearGradient(
                                    colors: AppColors.headerGradientColors,
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                  : null,
                          color:
                              controller.selectedType.value != -1
                                  ? null
                                  : (isDark
                                      ? AppColors.darkDivider
                                      : AppColors.lightDivider),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow:
                              controller.selectedType.value != -1
                                  ? [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16.r),
                            onTap:
                                controller.selectedType.value != -1
                                    ? controller.continueWithSelection
                                    : null,
                            child: Center(
                              child: Text(
                                'Continue',
                                style: AppTextStyles.button.copyWith(
                                  color:
                                      controller.selectedType.value != -1
                                          ? AppColors.white
                                          : (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Skip option
                    // TextButton(
                    //   onPressed: controller.skipForNow,
                    //   child: Text(
                    //     'Skip for now',
                    //     style: AppTextStyles.caption().copyWith(
                    //       color: AppColors.primaryColor,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required int index,
    required bool isDark,
    required List<String> features,
  }) {
    return Obx(() {
      final isSelected = controller.selectedType.value == index;

      return GestureDetector(
        onTap: () => controller.selectProfileType(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                    : null,
            color:
                isSelected
                    ? null
                    : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color:
                  isSelected
                      ? color
                      : (isDark
                          ? AppColors.darkDivider
                          : AppColors.lightDivider),
              width: isSelected ? 2.5 : 1.5,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                    : [],
          ),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.white.withValues(alpha: 0.2)
                                : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Icon(
                        icon,
                        size: 28.sp,
                        color: isSelected ? AppColors.white : color,
                      ),
                    ),

                    SizedBox(width: 16.w),

                    // Title and Badge
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTextStyles.headlineMedium().copyWith(
                              fontSize: 20.sp,
                              color:
                                  isSelected
                                      ? AppColors.white
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary),
                            ),
                          ),
                          if (index == 3) ...[
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? AppColors.white.withValues(alpha: 0.2)
                                        : AppColors.secondaryPrimary.withValues(
                                          alpha: 0.2,
                                        ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'RECOMMENDED',
                                style: AppTextStyles.small().copyWith(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected
                                          ? AppColors.white
                                          : AppColors.secondaryPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Checkmark
                    AnimatedScale(
                      scale: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 18.sp,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Description
                Text(
                  description,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 13.sp,
                    height: 1.4,
                    color:
                        isSelected
                            ? AppColors.white.withValues(alpha: 0.9)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                  ),
                ),

                SizedBox(height: 16.h),

                // Features
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children:
                      features.map((feature) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.white.withValues(alpha: 0.15)
                                    : color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.white.withValues(alpha: 0.3)
                                      : color.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 12.sp,
                                color: isSelected ? AppColors.white : color,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                feature,
                                style: AppTextStyles.small().copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected ? AppColors.white : color,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
