import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/signup_verification_controller.dart';


class SignupVerificationView extends GetView<SignupVerificationController> {
  const SignupVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            size: 20.sp,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),

                // Icon/Illustration
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.phone_android_rounded,
                    size: 50.sp,
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: 32.h),

                // Title
                Text(
                  'Verify Mobile Number',
                  style: AppTextStyles.headlineLarge(),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Subtitle
                Obx(() => RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.caption(),
                    children: [
                      const TextSpan(
                        text: 'We sent a 6-digit verification code to\n',
                      ),
                      TextSpan(
                        text: controller.maskedContact.value,
                        style: AppTextStyles.caption().copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )),

                SizedBox(height: 48.h),

                // OTP Input Fields (6 digits)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => _buildOTPBox(index, isDark),
                  ),
                ),

                SizedBox(height: 32.h),

                // Resend OTP Section
                Obx(() {
                  if (controller.canResend.value) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't receive the code? ",
                              style: AppTextStyles.caption(),
                            ),
                            GestureDetector(
                              onTap: controller.resendOTP,
                              child: Text(
                                'Resend',
                                style: AppTextStyles.caption().copyWith(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Other verification options
                        SizedBox(height: 24.h),
                        
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        //   decoration: BoxDecoration(
                        //     color: isDark 
                        //         ? AppColors.darkSurface.withValues(alpha: 0.5)
                        //         : AppColors.lightSurface,
                        //     borderRadius: BorderRadius.circular(12.r),
                        //     border: Border.all(
                        //       color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        //     ),
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Text(
                        //         'Try another way to verify',
                        //         style: AppTextStyles.caption().copyWith(
                        //           fontWeight: FontWeight.w600,
                        //         ),
                        //       ),
                        //       SizedBox(height: 12.h),
                              
                        //       // Call option
                        //       _buildVerificationOption(
                        //         icon: Icons.phone_in_talk_rounded,
                        //         title: 'Get a call',
                        //         subtitle: 'We\'ll call you with the code',
                        //         onTap: (){},
                        //         isDark: isDark,
                        //       ),
                              
                        //       SizedBox(height: 8.h),
                              
                        //       // WhatsApp option
                        //       _buildVerificationOption(
                        //         icon: Icons.message_rounded,
                        //         title: 'Send via WhatsApp',
                        //         subtitle: 'Receive code on WhatsApp',
                        //         onTap: (){},
                        //         isDark: isDark,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 16.sp,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Resend code in ',
                              style: AppTextStyles.caption(),
                            ),
                            Text(
                              '${controller.resendTimer.value}s',
                              style: AppTextStyles.caption().copyWith(
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Please wait before requesting a new code',
                          style: AppTextStyles.small().copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    );
                  }
                }),

                SizedBox(height: 48.h),

                // Verify Button
                Obx(() => Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    gradient: controller.otpComplete.value
                        ? LinearGradient(
                            colors: AppColors.headerGradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: controller.otpComplete.value
                        ? null
                        : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: controller.otpComplete.value
                        ? [
                            BoxShadow(
                              color: AppColors.primaryColor.withValues(alpha: 0.3),
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
                      onTap: controller.otpComplete.value && !controller.isVerifying.value
                          ? controller.verifyOTP
                          : null,
                      child: Center(
                        child: controller.isVerifying.value
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: CircularProgressIndicator(
                                      color: AppColors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    'Verifying...',
                                    style: AppTextStyles.button,
                                  ),
                                ],
                              )
                            : Text(
                                'Verify & Continue',
                                style: AppTextStyles.button.copyWith(
                                  color: controller.otpComplete.value
                                      ? AppColors.white
                                      : (isDark
                                          ? AppColors.darkTextSecondary
                                          : AppColors.lightTextSecondary),
                                ),
                              ),
                      ),
                    ),
                  ),
                )),

                SizedBox(height: 24.h),

                // Change Phone Number
                // TextButton(
                //   onPressed: () => Get.back(),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Icon(
                //         Icons.edit_outlined,
                //         size: 16.sp,
                //         color: AppColors.primaryColor,
                //       ),
                //       SizedBox(width: 4.w),
                //       Text(
                //         'Change phone number',
                //         style: AppTextStyles.caption().copyWith(
                //           color: AppColors.primaryColor,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPBox(int index, bool isDark) {
    return Container(
      width: 50.w,
      height: 50.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color:  controller.otpControllers[index].text.isNotEmpty
              ? AppColors.primaryColor
              : (isDark ? AppColors.darkDivider : AppColors.lightDivider)),
       
        
        boxShadow: controller.otpControllers[index].text.isNotEmpty
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : []
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.headlineLarge().copyWith(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            controller.focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }
          controller.checkOTPComplete();
        },
      ),
    );
  }

  // Widget _buildVerificationOption({
  //   required IconData icon,
  //   required String title,
  //   required String subtitle,
  //   required VoidCallback onTap,
  //   required bool isDark,
  // }) {
  //   return Material(
  //     color: Colors.transparent,
  //     child: InkWell(
  //       onTap: onTap,
  //       borderRadius: BorderRadius.circular(8.r),
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 40.w,
  //               height: 40.h,
  //               decoration: BoxDecoration(
  //                 color: AppColors.primaryColor.withValues(alpha: 0.1),
  //                 borderRadius: BorderRadius.circular(8.r),
  //               ),
  //               child: Icon(
  //                 icon,
  //                 color: AppColors.primaryColor,
  //                 size: 20.sp,
  //               ),
  //             ),
  //             SizedBox(width: 12.w),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: AppTextStyles.body().copyWith(
  //                       fontSize: 14.sp,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   SizedBox(height: 2.h),
  //                   Text(
  //                     subtitle,
  //                     style: AppTextStyles.small().copyWith(
  //                       color: isDark
  //                           ? AppColors.darkTextSecondary
  //                           : AppColors.lightTextSecondary,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios_rounded,
  //               size: 14.sp,
  //               color: isDark
  //                   ? AppColors.darkTextSecondary
  //                   : AppColors.lightTextSecondary,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  }