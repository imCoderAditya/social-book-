import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/new_post_controller.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';

class NewPostView extends GetView<NewPostController> {
  const NewPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBackground
              : AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileSection(),
                  _buildActionButtons(),
                  _buildTextInput(),
                  Obx(() => _buildSelectedFiles()),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color:
              Theme.of(Get.context!).brightness == Brightness.dark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text('New post', style: AppTextStyles.headlineMedium()),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    final profile = controller.profileController.userProfileModel.value?.data;
    return Container(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primaryColor,
            backgroundImage:
                (profile?.profilePictureUrl?.isNotEmpty ?? false)
                    ? NetworkImage(profile!.profilePictureUrl!)
                    : null,
            child:
                (profile?.profilePictureUrl?.isEmpty ?? true)
                    ? Icon(Icons.person, size: 24.r, color: AppColors.white)
                    : null,
          ),

          SizedBox(width: 12.w),
          Text(
            profile?.displayName ?? "",
            style: AppTextStyles.headlineMedium(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildActionChip(
              icon: Icons.music_note,
              label: 'Music',
              onTap: () => controller.onMusicTap(),
            ),
            SizedBox(width: 8.w),
            _buildActionChip(
              icon: Icons.people,
              label: 'People',
              onTap: () => controller.onPeopleTap(),
            ),
            SizedBox(width: 8.w),
            _buildActionChip(
              icon: Icons.location_on,
              label: 'Location',
              onTap: () => controller.onLocationTap(),
            ),
            SizedBox(width: 8.w),
            _buildActionChip(
              icon: Icons.emoji_emotions,
              label: 'Feeling',
              onTap: () => controller.onFeelingTap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkDivider
                    : AppColors.lightDivider,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20.sp,
              color:
                  Theme.of(Get.context!).brightness == Brightness.dark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
            SizedBox(width: 6.w),
            Text(label, style: AppTextStyles.caption()),
          ],
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: controller.contentController,
        maxLines: null,
        minLines: 5,
        decoration: InputDecoration(
          hintText: "What's on your mind?",
          hintStyle: AppTextStyles.body().copyWith(
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
          ),
          border: InputBorder.none,
        ),
        style: AppTextStyles.body(),
      ),
    );
  }

  Widget _buildSelectedFiles() {
    if (controller.selectedFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color:
          Theme.of(Get.context!).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
      padding: EdgeInsets.all(16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: controller.selectedFiles.length,
        itemBuilder: (context, index) {
          final file = controller.selectedFiles[index];
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.lightDivider,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                top: 4.h,
                right: 4.w,
                child: InkWell(
                  onTap: () => controller.removeFile(index),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, size: 16.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      decoration: BoxDecoration(
        color:
            Theme.of(Get.context!).brightness == Brightness.dark
                ? AppColors.darkSurface
                : AppColors.lightSurface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildBottomActionButton(
                icon: Icons.image,
                label: 'Gallery',
                onTap: () => controller.pickImages(),
              ),
              SizedBox(width: 12.w),
              _buildBottomActionButton(
                icon: Icons.auto_awesome,
                label: 'AI images',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              _buildBottomActionButton(
                icon: Icons.gif_box,
                label: 'GIF',
                onTap: () {},
              ),
              SizedBox(width: 12.w),
              _buildBottomActionButton(
                icon: Icons.circle,
                label: 'Life',
                onTap: () {},
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildPrivacyButton(),
              SizedBox(width: 12.w),
              _buildCameraButton(),
              const Spacer(),
              _buildPostButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24.sp,
                color:
                    Theme.of(Get.context!).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              SizedBox(height: 4.h),
              Text(label, style: AppTextStyles.small()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyButton() {
    return Obx(
      () => InkWell(
        onTap: () => controller.togglePrivacy(),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.privacyLevel.value == "Public"
                    ? Icons.public
                    : controller.privacyLevel.value == "Private"
                    ? Icons.lock
                    : Icons.people,
                size: 16.sp,
                color:
                    Theme.of(Get.context!).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              SizedBox(width: 6.w),
              Text(controller.privacyLevel.value, style: AppTextStyles.small()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return Obx(
      () => InkWell(
        onTap: () => controller.toggleCamera(),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color:
                Theme.of(Get.context!).brightness == Brightness.dark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.camera_alt,
                size: 16.sp,
                color:
                    Theme.of(Get.context!).brightness == Brightness.dark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
              SizedBox(width: 6.w),
              Text(controller.cameraStatus.value, style: AppTextStyles.small()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return Obx(
      () => InkWell(
        onTap:
            controller.isPosting.value ? null : () => controller.createPost(),
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child:
              controller.isPosting.value
                  ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Text('Post', style: AppTextStyles.button),
        ),
      ),
    );
  }
}
