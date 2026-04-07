import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:social_book/app/components/circle_image_view.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/core/config/theme/theme_controller.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return _buildDrawer(context, isDark, height, width);
  }

  Widget _buildDrawer(
    BuildContext context,
    bool isDark,
    double height,
    double width,
  ) {
    final themeController = Get.find<ThemeController>();
    final profileController = Get.find<ProfileController>();

    final profileData = profileController.profileModel.value?.data?.user;
    final userProfile = profileController.userProfileModel.value?.data;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final secondaryColor =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final highlightColor =
        isDark
            ? AppColors.primaryColor.withValues(alpha: 0.35)
            : AppColors.primaryColor.withValues(alpha: 0.18);

    final highlightTextColor =
        isDark ? AppColors.white : AppColors.primaryColor;
    return Drawer(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          Container(
            height: height * 0.30,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.headerGradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleImageView(
                    radius: 40.r,
                    image: userProfile?.profilePictureUrl ?? "",
                    displayName: userProfile?.displayName?[0] ?? "",
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    userProfile?.displayName ?? "",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    profileData?.email ?? "",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _profileGradient(userProfile?.profileType),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _profileIcon(userProfile?.profileType),
                          size: 14.sp,
                          color: AppColors.black,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          userProfile?.profileType ?? "",
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,

              children: [
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.home,
                  'Home',
                  () {},
                ),
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.home,
                  'Profile',
                  () {},
                ),
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.person,
                  'My Order',
                  () {
                    Get.back();
                    Get.toNamed(Routes.ORDER);
                  },
                ),

                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.settings,
                  'Settings',
                  () {},
                ),
                Divider(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.help_outline,
                  'Help & Support',
                  () {},
                ),
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.logout,
                  'Logout',
                  () {
                    LocalStorageService.logout().then((value) {
                      Get.back();
                      GetStorage().erase();
                      LocalStorageService.setPrimaryColor(
                        AppColors.primaryColorStr,
                      );
                      Get.offAllNamed(Routes.LOGIN);
                    });
                  },
                ),
                _buildDrawerItem(
                  context,
                  isDark,
                  height,
                  width,
                  Icons.switch_account,
                  'Switch Profile',
                  () {
                    Get.toNamed(Routes.SWITCH_PROFILE);
                  },
                ),
                SizedBox(height: 20.h),
                _buildThemeToggle(
                  themeController,
                  textColor,
                  highlightColor,
                  highlightTextColor,
                  secondaryColor,
                  isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _profileGradient(String? type) {
    switch (type) {
      case "Social":
        return [AppColors.white, AppColors.white];
      case "Professional":
        return [AppColors.white, AppColors.white];
      case "Hidden":
        return [AppColors.white, AppColors.white];
      case "Matrimonial":
        return [AppColors.white, AppColors.white];
      default:
        return [AppColors.white, AppColors.white];
    }
  }

  IconData _profileIcon(String? type) {
    switch (type) {
      case "Social":
        return Icons.people_alt;
      case "Professional":
        return Icons.work;
      case "Hidden":
        return Icons.visibility_off;
      case "Matrimonial":
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }

  Widget _buildDrawerItem(
    BuildContext context,
    bool isDark,
    double height,
    double width,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        size: height * 0.03,
      ),
      title: Text(
        title,
        style: AppTextStyles.body().copyWith(
          color:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggle(
    ThemeController themeController,
    Color textColor,
    Color highlightColor,
    Color highlightTextColor,
    Color secondaryColor,
    bool isDark,
  ) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => themeController.toggleTheme(),
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: AppColors.accentColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  "Dark Mode",
                  style: AppTextStyles.body().copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 52,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                      isDark
                          ? AppColors.accentColor
                          : secondaryColor.withValues(
                            alpha: 0.3,
                          ), // No clamp needed here
                  border: Border.all(
                    color:
                        isDark
                            ? AppColors.accentColor
                            : secondaryColor.withValues(
                              alpha: 0.5,
                            ), // No clamp needed here
                    width: 1,
                  ),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  alignment:
                      isDark ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.2,
                          ), // No clamp needed here
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isDark ? Icons.nightlight_round : Icons.wb_sunny,
                      size: 14,
                      color: isDark ? AppColors.accentColor : Colors.orange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
