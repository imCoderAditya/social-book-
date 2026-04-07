// Example toggle widget

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    debugPrint(controller.isDarkMode.value.toString());
    return Obx(
      () => Transform.scale(
        scale: 0.8,
        child: Switch(
          value: controller.isDarkMode.value,
          onChanged: (value) => controller.toggleTheme(),
          activeThumbColor: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
