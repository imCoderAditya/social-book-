import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
                SizedBox(height: 40.h),

                // Logo & Welcome Text
                Center(
                  child: Column(
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
                          Icons.lock_outline_rounded,
                          size: 40.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Welcome Back',
                        style: AppTextStyles.headlineLarge(),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign in to continue',
                        style: AppTextStyles.caption(),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 48.h),

                // Login Type Tabs
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
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            'Phone',
                            Icons.phone_android_rounded,
                            controller.loginType.value == LoginType.mobile,
                            () =>
                                controller.isLoading.value
                                    ? null
                                    : controller.loginType.value =
                                        LoginType.mobile,
                            isDark,
                          ),
                        ),
                        Expanded(
                          child: _buildTabButton(
                            'Email',
                            Icons.email_outlined,
                            controller.loginType.value == LoginType.email,
                            () =>
                                controller.isLoading.value
                                    ? null
                                    : controller.loginType.value =
                                        LoginType.email,
                            isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Login Forms
                Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child:
                        controller.loginType.value == LoginType.mobile
                            ? _buildPhoneLoginForm(isDark)
                            : _buildEmailLoginForm(isDark),
                  ),
                ),

                SizedBox(height: 24.h),

                // Forgot Password
                controller.loginType.value == LoginType.mobile
                    ? SizedBox()
                    : Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                SizedBox(height: 16.h),

                // Login Button
                Obx(
                  () => Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.r),
                        onTap:
                            controller.isLoading.value
                                ? null
                                : () {
                                  if (controller.loginType.value ==
                                      LoginType.mobile) {
                                    controller.sendOTP();
                                  } else {
                                    controller.login();
                                  }
                                },
                        child: Center(
                          child:
                              controller.isLoading.value
                                  ? SizedBox(
                                    width: 24.w,
                                    height: 24.h,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                  : Text(
                                    'Sign In',
                                    style: AppTextStyles.button,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Divider with OR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text('OR', style: AppTextStyles.caption()),
                    ),
                    Expanded(
                      child: Divider(
                        color:
                            isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Social Login Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        Icons.g_mobiledata_rounded,
                        'Google',
                        isDark,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildSocialButton(
                        Icons.apple_rounded,
                        'Apple',
                        isDark,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                // Sign Up Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.caption(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
                        child: Text(
                          'Sign Up',
                          style: AppTextStyles.caption().copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: AppColors.headerGradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color:
                  isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color:
                    isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneLoginForm(bool isDark) {
    return Column(
      key: const ValueKey('phone'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 20.sp,
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLength: 10,
              
                  decoration: InputDecoration(
                  counterText: "",
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
      ],
    );
  }

  Widget _buildEmailLoginForm(bool isDark) {
    return Column(
      key: const ValueKey('email'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
          child: TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppTextStyles.body().copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Enter email address',
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
        Text(
          'Password',
          style: AppTextStyles.subtitle().copyWith(fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
            ),
            child: TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              style: AppTextStyles.body().copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: 'Enter password',
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
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, bool isDark) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () {
            // Handle social login
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
