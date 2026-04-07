import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<NotificationController>(
      init: NotificationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            title: Text(
              'Notifications',
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
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                  size: 24.sp,
                ),
                onSelected: (value) {
                  if (value == 'mark_all_read') {
                    controller.markAllAsRead();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Icon(
                          Icons.done_all,
                          size: 20.sp,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Mark all as read',
                          style: AppTextStyles.caption(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Filter Tabs
              Container(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'All',
                        controller.selectedTab == 'all',
                        () => controller.changeTab('all'),
                        isDark,
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                        'Unread',
                        controller.selectedTab == 'unread',
                        () => controller.changeTab('unread'),
                        isDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Notifications List
              Expanded(
                child: controller.filteredNotifications.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.notifications_off_outlined,
                              size: 80.sp,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No notifications',
                              style: AppTextStyles.subtitle(),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        itemCount: controller.filteredNotifications.length,
                        itemBuilder: (context, index) {
                          final notification =
                              controller.filteredNotifications[index];
                          final isRead = notification['isRead'] as bool;
                          final type = notification['type'] as String;

                          return Dismissible(
                            key: Key(notification['id'].toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: AppColors.red,
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.w),
                              child: Icon(
                                Icons.delete,
                                color: AppColors.white,
                                size: 28.sp,
                              ),
                            ),
                            onDismissed: (direction) {
                              controller.deleteNotification(
                                  notification['id'] as int);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: isRead
                                    ? (isDark
                                        ? AppColors.darkSurface
                                        : AppColors.lightSurface)
                                    : AppColors.primaryColor.withOpacity(0.1),
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
                                      radius: 28.r,
                                      backgroundColor: _getNotificationColor(
                                              type)
                                          .withOpacity(0.2),
                                      child: Icon(
                                        _getNotificationIcon(type),
                                        size: 24.sp,
                                        color: _getNotificationColor(type),
                                      ),
                                    ),
                                    if (!isRead)
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          width: 12.w,
                                          height: 12.h,
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isDark
                                                  ? AppColors.darkSurface
                                                  : AppColors.lightSurface,
                                              width: 2.w,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: notification['user'] as String,
                                        style: AppTextStyles.caption().copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ' ${notification['message'] as String}',
                                        style: AppTextStyles.caption(),
                                      ),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    notification['time'] as String,
                                    style: AppTextStyles.small().copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                trailing: PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'mark_read') {
                                      controller.markAsRead(
                                          notification['id'] as int);
                                    } else if (value == 'delete') {
                                      controller.deleteNotification(
                                          notification['id'] as int);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (!isRead)
                                      PopupMenuItem(
                                        value: 'mark_read',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.done,
                                              size: 18.sp,
                                              color: isDark
                                                  ? AppColors.darkTextPrimary
                                                  : AppColors.lightTextPrimary,
                                            ),
                                            SizedBox(width: 12.w),
                                            Text(
                                              'Mark as read',
                                              style: AppTextStyles.small(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 18.sp,
                                            color: AppColors.red,
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            'Delete',
                                            style:
                                                AppTextStyles.small().copyWith(
                                              color: AppColors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  if (!isRead) {
                                    controller
                                        .markAsRead(notification['id'] as int);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(
      String label, bool isSelected, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : (isDark ? AppColors.darkBackground : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.caption().copyWith(
              color: isSelected
                  ? AppColors.white
                  : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'share':
        return Icons.share;
      case 'friend_request':
        return Icons.person_add;
      case 'friend_accept':
        return Icons.person;
      case 'mention':
        return Icons.alternate_email;
      case 'birthday':
        return Icons.cake;
      case 'event':
        return Icons.event;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'like':
        return AppColors.red;
      case 'comment':
        return AppColors.primaryColor;
      case 'share':
        return AppColors.green;
      case 'friend_request':
        return AppColors.accentColor;
      case 'friend_accept':
        return AppColors.green;
      case 'mention':
        return AppColors.secondaryPrimary;
      case 'birthday':
        return AppColors.yellow;
      case 'event':
        return AppColors.primaryColor;
      default:
        return AppColors.primaryColor;
    }
  }
}