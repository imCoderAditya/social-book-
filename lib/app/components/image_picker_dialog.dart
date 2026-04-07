import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/modules/auth/profileRegistration/controllers/profile_registration_controller.dart';

class ImagePickerDialog extends StatelessWidget {
  final ImageType imageType;

  const ImagePickerDialog({
    super.key,
    required this.imageType,
  });

  @override
  Widget build(BuildContext context) {
    final controller =Get.isRegistered<ProfileRegistrationController>()? Get.find<ProfileRegistrationController>():Get.put(ProfileRegistrationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSourceType.camera, imageType);
                  },
                  isDark: isDark,
                ),
                _buildOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSourceType.gallery, imageType);
                  },
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey : const Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: isDark 
              ? const Color(0xFF2C2C2C) 
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF677CE8),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white : const Color(0xFF212121),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, ImageType imageType) {
    showDialog(
      context: context,
      builder: (context) => ImagePickerDialog(imageType: imageType),
    );
  }
}