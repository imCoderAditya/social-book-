// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/modules/home/controllers/home_controller.dart';
import 'package:social_book/app/modules/onlineUser/controllers/online_user_controller.dart';
import '../controllers/nav_controller.dart';

class NavView extends GetView<NavController> {
  const NavView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Get.put(NavController());
    Get.put(HomeController());
    Get.put(OnlineUserController());
    return GetBuilder<NavController>(
      init: NavController(),
      builder: (controller) {
        return Scaffold(
          body: Obx(
            () => IndexedStack(
              index: controller.currentIndex.value,
              children: controller.pages,
            ),
          ),
          bottomNavigationBar: Obx(
            () => Container(
              decoration: BoxDecoration(
                color:
                    isDark
                        ? AppColors.darkBackground
                        : controller.currentIndex.value == 1
                        ? AppColors.backgroundDark
                        : AppColors.lightBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(0),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: BottomNavigationBar(
                  currentIndex: controller.currentIndex.value,
                  onTap: controller.changePage,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  selectedItemColor: AppColors.primaryColor,
                  unselectedItemColor:
                      isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                  selectedFontSize: 12,
                  unselectedFontSize: 11,
                  showUnselectedLabels: true,
                  items: [
                    _buildNavItem(
                      icon: Icons.home_rounded,
                      activeIcon: Icons.home,
                      label: 'Home',
                      index: 0,
                    ),
                    _buildNavItem(
                      icon: Icons.video_library_rounded,
                      activeIcon: Icons.video_library,
                      label: 'Reels',
                      index: 1,
                    ),
                    _buildNavItem(
                      icon: Icons.chat_bubble_outline_rounded,
                      activeIcon: Icons.chat_bubble,
                      label: 'Chat',
                      index: 2,
                    ),
                    _buildNavItem(
                      icon: Icons.store,
                      activeIcon: Icons.call,
                      label: 'Store',
                      index: 3,
                    ),
                    _buildNavItem(
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person,
                      label: 'Profile',
                      index: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color:
              controller.currentIndex.value == index
                  ? const Color(0xFF677CE8).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          controller.currentIndex.value == index ? activeIcon : icon,
          size: 26,
        ),
      ),
      label: label,
    );
  }
}
