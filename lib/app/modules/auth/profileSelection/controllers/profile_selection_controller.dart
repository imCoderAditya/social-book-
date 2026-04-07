// Profile Type Controller
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/routes/app_pages.dart';

class ProfileSelectionController extends GetxController {
  final selectedType = (-1).obs;

  void selectProfileType(int index) {
    selectedType.value = index;
  }

  void continueWithSelection() {
    // final types = ['Profile Picture', 'Social', 'Hidden', 'Professional'];

    //  Get.offAllNamed(Routes.NAV);

    Get.toNamed(Routes.PROFILE_REGISTRATION);

    // Navigate to next screen
    // Get.offAllNamed('/home');
  }

  void skipForNow() {
    Get.snackbar(
      'Skipped',
      'You can set your profile type later in settings',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryColor,
      colorText: AppColors.white,
      margin: EdgeInsets.all(16.w),
      borderRadius: 12.r,
      duration: const Duration(seconds: 2),
    );

    // Navigate to next screen
    // Get.offAllNamed('/home');
  }
}
