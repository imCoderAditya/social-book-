import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                // Back Button
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                    size: 20.sp,
                  ),
                  onPressed: () => Get.back(),
                  padding: EdgeInsets.zero,
                ),

                SizedBox(height: 20.h),

                // Header
                Text('Create Account', style: AppTextStyles.headlineLarge()),
                SizedBox(height: 8.h),
                Text('Sign up to get started', style: AppTextStyles.caption()),

                SizedBox(height: 40.h),

                // Email Field
                Text(
                  'Email Address',
                  style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                    ),
                  ),
                  child: TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: AppTextStyles.caption(),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 18.h,
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20.sp,
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Phone Number Field
                Text(
                  'Phone Number',
                  style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color:
                          isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color:
                                  isDark
                                      ? AppColors.darkDivider
                                      : AppColors.lightDivider,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('🇮🇳', style: TextStyle(fontSize: 20.sp)),
                            SizedBox(width: 4.w),
                            Text(
                              '+91',
                              style: AppTextStyles.body().copyWith(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                        
                          style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                          decoration: InputDecoration(
                            counter: SizedBox(),
                            hintText: 'Enter phone number',
                            hintStyle: AppTextStyles.caption(),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Password Field
                Text(
                  'Password',
                  style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                      ),
                    ),
                    child: TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                      decoration: InputDecoration(
                        hintText: 'Create password',
                        hintStyle: AppTextStyles.caption(),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 20.sp,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                          onPressed: () => controller.isPasswordHidden.toggle(),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Confirm Password Field
                Text(
                  'Confirm Password',
                  style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                      ),
                    ),
                    child: TextField(
                      controller: controller.confirmPasswordController,
                      obscureText: controller.isConfirmPasswordHidden.value,
                      style: AppTextStyles.body().copyWith(fontSize: 14.sp),
                      onChanged: (value) {
                        controller.confirmPasswordText.value = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Confirm your password',
                        hintStyle: AppTextStyles.caption(),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 18.h,
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          size: 20.sp,
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            size: 20.sp,
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                          ),
                          onPressed:
                              () => controller.isConfirmPasswordHidden.toggle(),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                // Password Match Indicator
                Obx(
                  () =>
                      controller.confirmPasswordText.value.isEmpty
                          ? SizedBox()
                          : Row(
                            children: [
                              Icon(
                                controller.passwordsMatch.value
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                size: 16.sp,
                                color:
                                    controller.passwordsMatch.value
                                        ? AppColors.green
                                        : AppColors.red,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                controller.passwordsMatch.value
                                    ? 'Passwords match'
                                    : 'Passwords do not match',
                                style: AppTextStyles.small().copyWith(
                                  color:
                                      controller.passwordsMatch.value
                                          ? AppColors.green
                                          : AppColors.red,
                                ),
                              ),
                            ],
                          ),
                ),

                SizedBox(height: 24.h),

                // Terms & Conditions
                Obx(
                  () => Row(
                    children: [
                      SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Checkbox(
                          value: controller.acceptedTerms.value,
                          onChanged:
                              (value) =>
                                  controller.acceptedTerms.value =
                                      value ?? false,
                          activeColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.acceptedTerms.toggle(),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.small(),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: AppTextStyles.small().copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTextStyles.small().copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
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

                SizedBox(height: 32.h),

                // Sign Up Button
                Obx(
                  () => Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient:
                          controller.isFormValid.value
                              ? LinearGradient(
                                colors: AppColors.headerGradientColors,
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              )
                              : null,
                      color:
                          controller.isFormValid.value
                              ? null
                              : (isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow:
                          controller.isFormValid.value
                              ? [
                                BoxShadow(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.3,
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
                            controller.isFormValid.value &&
                                    !controller.isLoading.value
                                ? controller.signUp
                                : null,
                        child: Center(
                          child:
                              controller.isLoading.value
                                  ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Text(
                                    'Create Account',
                                    style: AppTextStyles.button.copyWith(
                                      color:
                                          controller.isFormValid.value
                                              ? AppColors.white
                                              : (isDark
                                                  ? AppColors.darkTextSecondary
                                                  : AppColors
                                                      .lightTextSecondary),
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Already have account
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.caption(),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Sign In',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
