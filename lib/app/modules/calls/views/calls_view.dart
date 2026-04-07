import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/calls_controller.dart';

class CallsView extends GetView<CallsController> {
  const CallsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<CallsController>(
      init: CallsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            title: Text(
              'Calls',
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                onPressed: () {
                  controller.toggleSearch();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            children: [
              // Search Bar
              if (controller.isSearching)
                Container(
                  padding: EdgeInsets.all(16.w),
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  child: TextField(
                    controller: controller.searchController,
                    autofocus: true,
                    style: AppTextStyles.caption(),
                    decoration: InputDecoration(
                      hintText: 'Search calls...',
                      hintStyle: AppTextStyles.caption().copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                        onPressed: () {
                          controller.searchController.clear();
                          controller.filterCalls('');
                        },
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBackground
                          : AppColors.lightBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      controller.filterCalls(value);
                    },
                  ),
                ),

              // Calls List
              Expanded(
                child: controller.filteredCalls.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_outlined,
                              size: 80.sp,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No calls yet',
                              style: AppTextStyles.subtitle(),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: controller.filteredCalls.length,
                        itemBuilder: (context, index) {
                          final call = controller.filteredCalls[index];
                          final callType = call['type'] as String;
                          final isMissed = call['isMissed'] as bool;

                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 24.r,
                                    backgroundColor: AppColors.primaryColor
                                        .withOpacity(0.2),
                                    child: Icon(
                                      Icons.person,
                                      size: 24.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.darkSurface
                                            : AppColors.lightSurface,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        callType == 'video'
                                            ? Icons.videocam
                                            : Icons.call,
                                        size: 12.sp,
                                        color: isMissed
                                            ? AppColors.red
                                            : callType == 'incoming'
                                                ? AppColors.green
                                                : isDark
                                                    ? AppColors.darkTextSecondary
                                                    : AppColors
                                                        .lightTextSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(
                                call['name'] as String,
                                style: AppTextStyles.caption().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: isMissed
                                      ? AppColors.red
                                      : isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Icon(
                                    callType == 'incoming'
                                        ? Icons.call_received
                                        : callType == 'outgoing'
                                            ? Icons.call_made
                                            : Icons.call_missed,
                                    size: 14.sp,
                                    color: isMissed
                                        ? AppColors.red
                                        : isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    call['time'] as String,
                                    style: AppTextStyles.small().copyWith(
                                      color: isMissed
                                          ? AppColors.red
                                          : isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  callType == 'video'
                                      ? Icons.videocam
                                      : Icons.call,
                                  color: AppColors.primaryColor,
                                  size: 24.sp,
                                ),
                                onPressed: () {
                                  // Make call
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add new call
            },
            backgroundColor: AppColors.primaryColor,
            child: Icon(
              Icons.add_call,
              color: AppColors.white,
              size: 28.sp,
            ),
          ),
        );
      },
    );
  }
}