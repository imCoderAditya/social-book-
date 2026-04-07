import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class ProfileShimmer extends StatelessWidget {
  final bool isDark;

  const ProfileShimmer({
    super.key,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // Cover Photo & Profile Header Shimmer
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            backgroundColor: AppColors.primaryColor.withValues(alpha: 0.5),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Cover Photo Shimmer
                  _buildShimmerBox(
                    width: double.infinity,
                    height: 280.h,
                    borderRadius: 0,
                  ),

                  // Profile Picture Shimmer
                  Positioned(
                    bottom: 20.h,
                    left: 16.w,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackground
                              : AppColors.lightBackground,
                          width: 4.w,
                        ),
                      ),
                      child: _buildShimmerBox(
                        width: 120.r,
                        height: 120.r,
                        isCircle: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Info & Content Shimmer
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Name and Bio Section Shimmer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Shimmer
                      _buildShimmerBox(
                        width: 200.w,
                        height: 28.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 8.h),
                      // Friends Count Shimmer
                      _buildShimmerBox(
                        width: 100.w,
                        height: 14.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 16.h),
                      // Bio Shimmer
                      _buildShimmerBox(
                        width: double.infinity,
                        height: 14.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 8.h),
                      _buildShimmerBox(
                        width: 250.w,
                        height: 14.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 16.h),

                      // Action Buttons Shimmer
                      Row(
                        children: [
                          Expanded(
                            child: _buildShimmerBox(
                              width: double.infinity,
                              height: 44.h,
                              borderRadius: 8.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildShimmerBox(
                              width: double.infinity,
                              height: 44.h,
                              borderRadius: 8.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildShimmerBox(
                            width: 44.w,
                            height: 44.h,
                            borderRadius: 8.r,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                // Details Section Shimmer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerBox(
                        width: 100.w,
                        height: 22.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 16.h),
                      ...List.generate(
                        5,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            children: [
                              _buildShimmerBox(
                                width: 20.sp,
                                height: 20.sp,
                                isCircle: true,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildShimmerBox(
                                  width: double.infinity,
                                  height: 14.h,
                                  borderRadius: 8.r,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),

                // Friends Section Shimmer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildShimmerBox(
                            width: 80.w,
                            height: 22.h,
                            borderRadius: 8.r,
                          ),
                          _buildShimmerBox(
                            width: 60.w,
                            height: 18.h,
                            borderRadius: 8.r,
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      _buildShimmerBox(
                        width: 100.w,
                        height: 14.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 180.h,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 9.w,
                            childAspectRatio: 2 / 2.5,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                _buildShimmerBox(
                                  width: 60.r,
                                  height: 60.r,
                                  isCircle: true,
                                ),
                                SizedBox(height: 6.h),
                                _buildShimmerBox(
                                  width: 50.w,
                                  height: 12.h,
                                  borderRadius: 8.r,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),

                // Posts Section Shimmer
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      _buildShimmerBox(
                        width: 80.w,
                        height: 22.h,
                        borderRadius: 8.r,
                      ),
                      SizedBox(height: 10.h),
                      ...List.generate(
                        3,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _buildPostCardShimmer(),
                        ),
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
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    double borderRadius = 0,
    bool isCircle = false,
  }) {
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkBackground : AppColors.lightDivider,
      highlightColor: isDark ? AppColors.darkDivider : AppColors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBackground : AppColors.white,
          borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  Widget _buildPostCardShimmer() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Row(
            children: [
              _buildShimmerBox(
                width: 40.r,
                height: 40.r,
                isCircle: true,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(
                      width: 120.w,
                      height: 14.h,
                      borderRadius: 8.r,
                    ),
                    SizedBox(height: 4.h),
                    _buildShimmerBox(
                      width: 80.w,
                      height: 12.h,
                      borderRadius: 8.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Post Content
          _buildShimmerBox(
            width: double.infinity,
            height: 14.h,
            borderRadius: 8.r,
          ),
          SizedBox(height: 6.h),
          _buildShimmerBox(
            width: 200.w,
            height: 14.h,
            borderRadius: 8.r,
          ),
          SizedBox(height: 12.h),
          // Post Image
          _buildShimmerBox(
            width: double.infinity,
            height: 180.h,
            borderRadius: 10.r,
          ),
          SizedBox(height: 12.h),
          // Post Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildShimmerBox(
                width: 60.w,
                height: 20.h,
                borderRadius: 8.r,
              ),
              _buildShimmerBox(
                width: 60.w,
                height: 20.h,
                borderRadius: 8.r,
              ),
              _buildShimmerBox(
                width: 60.w,
                height: 20.h,
                borderRadius: 8.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}