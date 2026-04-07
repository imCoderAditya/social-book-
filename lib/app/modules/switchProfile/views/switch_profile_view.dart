// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/components/restart_widget.dart'
    show RestartWidget;
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/modules/switchProfile/controllers/switch_profile_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';

class SwitchProfileView extends StatelessWidget {
  const SwitchProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<SwitchProfileController>(
      init: SwitchProfileController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFF5F5F5),
            appBar: AppBar(
              elevation: 0,

              backgroundColor: Colors.transparent,
              // leading: IconButton(
              //   icon: Icon(
              //     Icons.arrow_back,
              //     color: isDark ? Colors.white : Colors.black,
              //   ),
              //   onPressed: () => Get.back(),
              // ),
              title: Text(
                'Switch Profile',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Color(0xFF212121),
                ),
              ),
              centerTitle: true,
            ),
            body: Obx(() {
              if (controller.isFetching.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF677CE8),
                    ),
                  ),
                );
              }

              final profiles = controller.profileTypeModel.value?.profiles;
              if (profiles == null || profiles.isEmpty) {
                return Center(
                  child: Text(
                    'No profiles available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  Column(
                    children: [
                      // Current Profile Header
                      Obx(
                        () =>
                            controller.selectedProfileType.value == null
                                ? SizedBox()
                                : Container(
                                  margin: EdgeInsets.all(16.w),
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        controller.currentProfileColor,
                                        controller.currentProfileColor
                                            .withValues(alpha: 0.7),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: controller.currentProfileColor
                                            .withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 56.h,
                                        width: 56.w,
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: CommonNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              controller
                                                  .selectedProfileType
                                                  .value
                                                  ?.icon ??
                                              "",
                                          backgroundColor: Colors.white,
                                          height: 50.h,
                                          width: 50.w,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Current Profile',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              controller
                                                      .selectedProfileType
                                                      .value
                                                      ?.type ??
                                                  "",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                        size: 28.sp,
                                      ),
                                    ],
                                  ),
                                ),
                      ),

                      // Profile List
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          physics: BouncingScrollPhysics(),
                          itemCount: profiles.length,
                          itemBuilder: (context, index) {
                            final profile = profiles[index];
                            final isSelected =
                                controller.selectedProfileIndex.value == index;
                            // controller.selectedProfileProfileId.value ==
                            // profile.profileId;
                            log(index);

                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => controller.switchProfile(index),
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color:
                                          isDark
                                              ? Color(0xFF1E1E1E)
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? hexToColor(
                                                  profile.color.toString(),
                                                )
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              isSelected
                                                  ? hexToColor(
                                                    profile.color.toString(),
                                                  ).withValues(alpha: 0.2)
                                                  : Colors.black.withValues(
                                                    alpha: 0.05,
                                                  ),
                                          blurRadius: isSelected ? 12 : 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        // Icon
                                        Container(
                                          width: 56.w,
                                          height: 56.h,
                                          padding: EdgeInsets.all(8.r),
                                          decoration: BoxDecoration(
                                            color: hexToColor(
                                              profile.color ?? "",
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: CommonNetworkImage(
                                            imageUrl: profile.icon??"",
                                            backgroundColor: AppColors.white,
                                            fit: BoxFit.fill,
                                            height: 50.h,
                                            width: 50.w,
                                            borderRadius: BorderRadiusGeometry.circular(100),
                                          ),
                                        ),
                                        SizedBox(width: 16.w),

                                        // Profile Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                profile.type ?? "",
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      isDark
                                                          ? Colors.white
                                                          : Color(0xFF212121),
                                                ),
                                              ),
                                              if (profile.description != null &&
                                                  profile
                                                      .description!
                                                      .isNotEmpty) ...[
                                                SizedBox(height: 4.h),
                                                Text(
                                                  profile.description!,
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color:
                                                        isDark
                                                            ? Colors.white60
                                                            : Colors.grey[600],
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                              if (profile.type != null) ...[],
                                              if (profile.profileId ==
                                                  null) ...[
                                                SizedBox(height: 4.h),
                                                Text(
                                                  "Register now",
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    color: AppColors.black
                                                        .withValues(alpha: 0.8),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ] else ...[
                                                SizedBox(height: 4.h),
                                                Text(
                                                  profile.type!.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: hexToColor(
                                                      profile.color.toString(),
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),

                                        // Selection Indicator
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          width: 24.w,
                                          height: 24.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                isSelected
                                                    ? hexToColor(
                                                      profile.color.toString(),
                                                    )
                                                    : Colors.transparent,
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? hexToColor(
                                                        profile.color
                                                            .toString(),
                                                      )
                                                      : Colors.grey.withValues(
                                                        alpha: 0.3,
                                                      ),
                                              width: 2,
                                            ),
                                          ),
                                          child:
                                              isSelected
                                                  ? Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 16.sp,
                                                  )
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Continue Button
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.all(16.w),
                          child: ElevatedButton(
                            onPressed:
                                controller.selectedProfileType.value == null
                                    ? null
                                    : () async {
                                      if (controller
                                              .selectedProfileProfileId
                                              .value !=
                                          0) {
                                        if (Get.context != null) {
                                          await Get.deleteAll(force: true);

                                          RestartWidget.restartApp(
                                            Get.context!,
                                          );
                                        }
                                      } else {
                                        Get.toNamed(
                                          Routes.PROFILE_REGISTRATION,
                                          arguments: {
                                            "profileType":
                                                controller
                                                    .selectedProfileType
                                                    .value
                                                    ?.type ??
                                                "",
                                          },
                                        );
                                      }
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.currentProfileColor,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue with ${controller.selectedProfileType.value?.type ?? ""}',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Loading Overlay
                  Obx(
                    () =>
                        controller.isLoading.value
                            ? Container(
                              color: AppColors.black.withValues(alpha: 0.5),
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(24.w),
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? Color(0xFF1E1E1E)
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              controller.currentProfileColor,
                                            ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'Switching Profile...',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              isDark
                                                  ? Colors.white
                                                  : Color(0xFF212121),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
