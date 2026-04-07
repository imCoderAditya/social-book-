
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/custom_text_field.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : const Color(0xFFF8F9FA),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Loading profile...',
                  style: AppTextStyles.body().copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            // Custom App Bar with Cover Image
            _buildSliverAppBar(context, isDark),
            

            // Content
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20), // Space for profile image overlap
                // Form Content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        // Basic Information
                        _buildModernSection(
                          context: context,
                          title: 'Basic Information',
                          icon: Icons.person_outline,
                          isDark: isDark,
                          children: [
                            CustomTextField(
                              controller: controller.displayNameController,
                              label: 'Display Name',
                              hint: 'Enter your name',
                              prefixIcon: Icons.badge_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.bioController,
                              label: 'Bio',
                              hint: 'Tell us about yourself',
                              prefixIcon: Icons.edit_note,
                              maxLines: 3,
                              maxLength: 150,
                            ),
                            const SizedBox(height: 16),
                            _buildModernDropdown(
                              context: context,
                              label: 'Gender',
                              value: controller.selectedGender.value,
                              items: controller.genderOptions,
                              onChanged:
                                  (value) =>
                                      controller.selectedGender.value = value!,
                              icon: Icons.wc_outlined,
                              isDark: isDark,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Birth Details
                        _buildModernSection(
                          context: context,
                          title: 'Birth Details',
                          icon: Icons.cake_outlined,
                          isDark: isDark,
                          children: [
                            CustomTextField(
                              controller: controller.dateOfBirthController,
                              label: 'Date of Birth',
                              hint: 'Select date',
                              prefixIcon: Icons.calendar_today_outlined,
                              readOnly: true,
                              onTap: () => controller.selectDate(context),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.timeOfBirthController,
                              label: 'Time of Birth',
                              hint: 'Select time',
                              prefixIcon: Icons.access_time_outlined,
                              readOnly: true,
                              onTap: () => controller.selectTime(context),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.placeOfBirthController,
                              label: 'Place of Birth',
                              hint: 'Enter place',
                              prefixIcon: Icons.location_on_outlined,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Location
                        _buildModernSection(
                          context: context,
                          title: 'Location',
                          icon: Icons.map_outlined,
                          isDark: isDark,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.cityController,
                                    label: 'City',
                                    hint: 'City',
                                    prefixIcon: Icons.location_city_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.stateController,
                                    label: 'State',
                                    hint: 'State',
                                    prefixIcon: Icons.map_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.countryController,
                                    label: 'Country',
                                    hint: 'Country',
                                    prefixIcon: Icons.flag_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.pincodeController,
                                    label: 'Pincode',
                                    hint: 'Pincode',
                                    prefixIcon: Icons.pin_drop_outlined,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.hometownController,
                                    label: 'Hometown',
                                    hint: 'Hometown',
                                    prefixIcon: Icons.home_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.livingInController,
                                    label: 'Living In',
                                    hint: 'Current',
                                    prefixIcon: Icons.house_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Education & Work
                        _buildModernSection(
                          context: context,
                          title: 'Education & Career',
                          icon: Icons.school_outlined,
                          isDark: isDark,
                          children: [
                            CustomTextField(
                              controller: controller.educationController,
                              label: 'Education',
                              hint: 'Your highest qualification',
                              prefixIcon: Icons.school_outlined,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.professionController,
                              label: 'Profession',
                              hint: 'Your job title',
                              prefixIcon: Icons.work_outline,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.companyController,
                              label: 'Company',
                              hint: 'Company name',
                              prefixIcon: Icons.business_outlined,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.workAtController,
                                    label: 'Work At',
                                    hint: 'Workplace',
                                    prefixIcon: Icons.business_center_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller:
                                        controller.workLocationController,
                                    label: 'Work Location',
                                    hint: 'Location',
                                    prefixIcon: Icons.place_outlined,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildModernExperienceSlider(context, isDark),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: controller.skillsController,
                              label: 'Skills',
                              hint: 'e.g. Flutter, Dart, Firebase',
                              prefixIcon: Icons.star_outline,
                              maxLines: 2,
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Personal Details
                        _buildModernSection(
                          context: context,
                          title: 'Personal Details',
                          icon: Icons.favorite_outline,
                          isDark: isDark,
                          children: [
                            _buildModernDropdown(
                              context: context,
                              label: 'Relationship Status',
                              value:
                                  controller.selectedRelationshipStatus.value,
                              items: controller.relationshipOptions,
                              onChanged:
                                  (value) =>
                                      controller
                                          .selectedRelationshipStatus
                                          .value = value!,
                              icon: Icons.favorite_outline,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildModernDropdown(
                              context: context,
                              label: 'Marital Status',
                              value: controller.selectedMaritalStatus.value,
                              items: controller.maritalOptions,
                              onChanged:
                                  (value) =>
                                      controller.selectedMaritalStatus.value =
                                          value!,
                              icon: Icons.group_outlined,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            _buildModernDropdown(
                              context: context,
                              label: 'Blood Group',
                              value: controller.selectedBloodGroup.value,
                              items: controller.bloodGroupOptions,
                              onChanged:
                                  (value) =>
                                      controller.selectedBloodGroup.value =
                                          value!,
                              icon: Icons.bloodtype_outlined,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller:
                                        controller.motherTongueController,
                                    label: 'Mother Tongue',
                                    hint: 'Language',
                                    prefixIcon: Icons.language_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: controller.languageController,
                                    label: 'Languages',
                                    hint: 'Hindi, English',
                                    prefixIcon: Icons.translate_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Other
                        _buildModernSection(
                          context: context,
                          title: 'Additional Info',
                          icon: Icons.link,
                          isDark: isDark,
                          children: [
                            CustomTextField(
                              controller: controller.websiteController,
                              label: 'Website',
                              hint: 'https://yourwebsite.com',
                              prefixIcon: Icons.language,
                              keyboardType: TextInputType.url,
                            ),
                          ],
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        );
      }),

      // Floating Save Button
      floatingActionButton: Obx(
        () => AnimatedScale(
          scale: controller.isSaving.value ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton.extended(
            onPressed:
                controller.isSaving.value
                    ? null
                    : () => controller.updateProfile(),
            backgroundColor: AppColors.primaryColor,
            elevation: 8,
            icon:
                controller.isSaving.value
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.check, color: Colors.white),
            label: Text(
              controller.isSaving.value ? 'Saving...' : 'Save Changes',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 60.h,
      pinned: true,
      elevation: 0,
      title: Text("Edit Profile",style: AppTextStyles.button.copyWith(
        color: AppColors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),),
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Cover Image
            // Obx(() {
            //   final hasCoverFile = controller.coverImage.value != null;
            //   final hasCoverUrl = controller.coverImageUrl.value.isNotEmpty;

            //   return GestureDetector(
            //     onTap: () => ImagePickerDialog.show(context, ImageType.cover),
            //     child:
            //         hasCoverFile
            //             ? Image.file(
            //               controller.coverImage.value?.path as File,
            //               fit: BoxFit.cover,
            //             )
            //             : hasCoverUrl
            //             ? CommonNetworkImage(
            //               imageUrl: controller.coverImageUrl.value,
            //               width: double.infinity,
            //               height: 280,
            //               fit: BoxFit.cover,
            //               borderRadius: BorderRadius.zero,
            //             )
            //             : Container(
            //               decoration: BoxDecoration(
            //                 gradient: LinearGradient(
            //                   begin: Alignment.topLeft,
            //                   end: Alignment.bottomRight,
            //                   colors: [
            //                     AppColors.primaryColor,
            //                     AppColors.accentColor,
            //                   ],
            //                 ),
            //               ),
            //               child: Center(
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Icon(
            //                       Icons.add_photo_alternate_outlined,
            //                       size: 48,
            //                       color: Colors.white.withValues(alpha: 0.9),
            //                     ),
            //                     const SizedBox(height: 8),
            //                     Text(
            //                       'Add Cover Photo',
            //                       style: TextStyle(
            //                         color: Colors.white.withValues(alpha: 0.9),
            //                         fontSize: 16,
            //                         fontWeight: FontWeight.w500,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //   );
            // }),

            // // Gradient Overlay
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: [
            //         Colors.transparent,
            //         Colors.black.withValues(alpha: 0.3),
            //       ],
            //     ),
            //   ),
            // ),

            // // Edit Cover Button
            // Obx(() {
            //   final hasImage =
            //       controller.coverImage.value != null ||
            //       controller.coverImageUrl.value.isNotEmpty;

            //   return hasImage
            //       ? Positioned(
            //         top: 60.h,
            //         right: 16,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: AppColors.backgroundDark.withValues(alpha: 0.4),
            //             shape: BoxShape.circle,
            //             boxShadow: [
            //               BoxShadow(
            //                 color: Colors.black.withValues(alpha: 0.2),
            //                 blurRadius: 8,
            //                 offset: const Offset(0, 2),
            //               ),
            //             ],
            //           ),
            //           child: IconButton(
            //             icon: Icon(Icons.camera_alt, color: AppColors.white),
            //             onPressed: () => controller.imageUpload(),
            //           ),
            //         ),
            //       )
            //       : const SizedBox.shrink();
            // }),

            // // Profile Picture
            // Positioned(
            //   bottom: 20,
            //   left: 16,
            //   child: Obx(() {
            //     final hasProfileFile = controller.profileImage.value != null;
            //     final hasProfileUrl =
            //         controller.profileImageUrl.value.isNotEmpty;

            //     return GestureDetector(
            //       onTap: () => controller.imageUpload(),
            //       child: Container(
            //         width: 110,
            //         height: 110,
            //         decoration: BoxDecoration(
            //           shape: BoxShape.circle,
            //           border: Border.all(color: Colors.white, width: 4),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withValues(alpha: 0.3),
            //               blurRadius: 12,
            //               offset: const Offset(0, 4),
            //             ),
            //           ],
            //         ),
            //         child: Stack(
            //           children: [
            //             ClipOval(
            //               child:
            //                   hasProfileFile
            //                       ? Image.file(
            //                         File(controller.profileImage.value!.path),
            //                         width: 110,
            //                         height: 110,
            //                         fit: BoxFit.cover,
            //                       )
            //                       : hasProfileUrl
            //                       ? CommonNetworkImage(
            //                         imageUrl: controller.profileImageUrl.value,
            //                         width: 110,
            //                         height: 110,
            //                         fit: BoxFit.cover,
            //                         borderRadius: BorderRadius.zero,
            //                       )
            //                       : Container(
            //                         color: AppColors.primaryColor.withValues(
            //                           alpha: 0.2,
            //                         ),
            //                         child: Icon(
            //                           Icons.person_outline,
            //                           size: 50,
            //                           color: AppColors.primaryColor,
            //                         ),
            //                       ),
            //             ),
            //             Positioned(
            //               bottom: 0,
            //               right: 0,
            //               child: Container(
            //                 padding: const EdgeInsets.all(8),
            //                 decoration: BoxDecoration(
            //                   color: AppColors.primaryColor,
            //                   shape: BoxShape.circle,
            //                   border: Border.all(color: Colors.white, width: 2),
            //                 ),
            //                 child: const Icon(
            //                   Icons.camera_alt,
            //                   color: Colors.white,
            //                   size: 16,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     );
            //   }),
            // ),
         
          ],
        ),
      ),
    );
  }

  // Widget _buildProfileNameCard(bool isDark) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: isDark ? AppColors.darkSurface : Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color:
  //               isDark
  //                   ? Colors.black.withValues(alpha: 0.3)
  //                   : Colors.grey.withValues(alpha: 0.1),
  //           blurRadius: 10,
  //           offset: const Offset(0, 4),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           controller.displayNameController.text.isEmpty
  //               ? 'Your Name'
  //               : controller.displayNameController.text,
  //           style: AppTextStyles.headlineLarge().copyWith(fontSize: 24),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           controller.bioController.text.isEmpty
  //               ? 'Add a bio to tell people about yourself'
  //               : controller.bioController.text,
  //           style: AppTextStyles.caption().copyWith(fontSize: 14),
  //           maxLines: 2,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         if (controller.cityController.text.isNotEmpty) ...[
  //           const SizedBox(height: 12),
  //           Row(
  //             children: [
  //               Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
  //               const SizedBox(width: 4),
  //               Text(
  //                 controller.cityController.text,
  //                 style: AppTextStyles.caption(),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  Widget _buildModernSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                isDark
                    ? Colors.black.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColors.primaryColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineMedium().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body().copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryColor, size: 20),
            filled: true,
            fillColor:
                isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
          dropdownColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          style: AppTextStyles.body().copyWith(
            color: isDark ? AppColors.white : AppColors.backgroundDark,
          ),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildModernExperienceSlider(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience Years',
          style: AppTextStyles.body().copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.experienceYears.value == 0
                            ? 'Fresher'
                            : controller.experienceYears.value >= 20
                            ? '20+ Years'
                            : '${controller.experienceYears.value} ${controller.experienceYears.value == 1 ? 'Year' : 'Years'}',
                        style: AppTextStyles.headlineMedium().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Professional Experience',
                        style: AppTextStyles.caption().copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.experienceYears.value}',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 24,
                  ),
                  activeTrackColor: AppColors.primaryColor,
                  inactiveTrackColor:
                      isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  thumbColor: AppColors.primaryColor,
                  overlayColor: AppColors.primaryColor.withValues(alpha: 0.2),
                ),
                child: Slider(
                  value: controller.experienceYears.value.toDouble(),
                  min: 0,
                  max: 20,
                  divisions: 20,
                  onChanged: (value) {
                    controller.experienceYears.value = value.toInt();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
