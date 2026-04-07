// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background circles for depth
            Positioned(
              top: -100.h,
              right: -100.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -150.h,
              left: -150.w,
              child: Container(
                width: 400.w,
                height: 400.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.05),
                ),
              ),
            ),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo container
                  Obx(
                    () => AnimatedScale(
                      scale: controller.logoScale.value,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      child: AnimatedOpacity(
                        opacity: controller.logoOpacity.value,
                        duration: const Duration(milliseconds: 600),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(16),
                          child: Container(
                            width: 170.w,
                            height: 170.h,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.rectangle,
                          
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/logo.jpeg"),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // App name with animation
                  Obx(
                    () => AnimatedOpacity(
                      opacity: controller.textOpacity.value,
                      duration: const Duration(milliseconds: 800),
                      child: AnimatedSlide(
                        offset: Offset(0, controller.textSlideOffset.value),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        child: Column(
                          children: [
                            Text(
                              'Social Book',
                              style: AppTextStyles.brandLogo.copyWith(
                                fontSize: 42.sp,
                                color: AppColors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Connect • Share • Inspire',
                              style: AppTextStyles.caption().copyWith(
                                fontSize: 14.sp,
                                color: AppColors.white.withOpacity(0.9),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading indicator at bottom
            Positioned(
              bottom: 80.h,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.loaderOpacity.value,
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40.w,
                        height: 40.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Loading your experience...',
                        style: AppTextStyles.small().copyWith(
                          fontSize: 12.sp,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Company info at bottom
            Positioned(
              bottom: 24.h,
              left: 0,
              right: 0,
              child: Obx(
                () => AnimatedOpacity(
                  opacity: controller.footerOpacity.value,
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    children: [
                      Text(
                        'from',
                        style: AppTextStyles.small().copyWith(
                          fontSize: 11.sp,
                          color: AppColors.white.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'A SOCIAL BOOK',
                        style: AppTextStyles.caption().copyWith(
                          fontSize: 13.sp,
                          color: AppColors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
