import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/custom_text_field.dart';
import 'package:social_book/app/components/image_picker_dialog.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/profile_registration_controller.dart';

class ProfileRegistrationView extends GetView<ProfileRegistrationController> {
  const ProfileRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<ProfileRegistrationController>(
      init: ProfileRegistrationController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  // Cover & Profile Image Header
                  SliverToBoxAdapter(child: _buildHeader(context, isDark)),

                  // Form Fields
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: controller.displayNameController,
                              label: 'Display Name',
                              hint: 'Enter your display name',
                              prefixIcon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter display name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),

                            CustomTextField(
                              controller: controller.bioController,
                              label: 'Bio',
                              hint: 'Tell us about yourself',
                              prefixIcon: Icons.description,
                              maxLines: 4,
                            ),
                            SizedBox(height: 16.h),

                            Obx(
                              () => CustomTextField(
                                controller: TextEditingController(
                                  text:
                                      controller.dateOfBirth.value != null
                                          ? '${controller.dateOfBirth.value!.day}/${controller.dateOfBirth.value!.month}/${controller.dateOfBirth.value!.year}'
                                          : '',
                                ),
                                label: 'Date of Birth',
                                hint: 'Select date of birth',
                                prefixIcon: Icons.calendar_today,
                                readOnly: true,
                                onTap:
                                    () => controller.selectDateOfBirth(context),
                                validator: (value) {
                                  if (controller.dateOfBirth.value == null) {
                                    return 'Please select date of birth';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Obx(
                            //   () => CustomTextField(
                            //     controller: TextEditingController(
                            //       text:
                            //           controller.timeOfBirth.value != null
                            //               ? controller.timeOfBirth.value!.format(
                            //                 context,
                            //               )
                            //               : '',
                            //     ),
                            //     label: 'Time of Birth',
                            //     hint: 'Select time of birth',
                            //     prefixIcon: Icons.access_time,
                            //     readOnly: true,
                            //     onTap: () => controller.selectTimeOfBirth(context),
                            //   ),
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.placeOfBirthController,
                            //   label: 'Place of Birth',
                            //   hint: 'Enter place of birth',
                            //   prefixIcon: Icons.location_on,
                            // ),

                            // SizedBox(height: 16.h),
                            _buildGenderDropdown(isDark),

                            SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.cityController,
                            //   label: 'City',
                            //   hint: 'Enter city',
                            //   prefixIcon: Icons.location_city,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.stateController,
                            //   label: 'State',
                            //   hint: 'Enter state',
                            //   prefixIcon: Icons.map,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.countryController,
                            //   label: 'Country',
                            //   hint: 'Enter country',
                            //   prefixIcon: Icons.flag,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.pincodeController,
                            //   label: 'Pincode',
                            //   hint: 'Enter pincode',
                            //   prefixIcon: Icons.pin_drop,
                            //   keyboardType: TextInputType.number,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.educationController,
                            //   label: 'Education',
                            //   hint: 'Enter education',
                            //   prefixIcon: Icons.school,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.professionController,
                            //   label: 'Profession',
                            //   hint: 'Enter profession',
                            //   prefixIcon: Icons.work,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.companyController,
                            //   label: 'Company',
                            //   hint: 'Enter company name',
                            //   prefixIcon: Icons.business,
                            // ),
                            // SizedBox(height: 16.h),

                            // CustomTextField(
                            //   controller: controller.websiteController,
                            //   label: 'Website',
                            //   hint: 'Enter website URL',
                            //   prefixIcon: Icons.link,
                            //   keyboardType: TextInputType.url,
                            // ),
                            // SizedBox(height: 16.h),
                            // CustomTextField(
                            //   controller: controller.languageController,
                            //   label: 'Language',
                            //   hint: 'Enter preferred language',
                            //   prefixIcon: Icons.language,
                            // ),
                            // SizedBox(height: 16.h),
                            controller.profileType?.value == "Hidden"
                                ? _buildVerificationDocument(context, isDark)
                                : SizedBox(),
                            // SizedBox(height: 16.h),
                            // _buildProfileTypeDropdown(isDark),
                            SizedBox(height: 16.h),
                            _buildSubmitButton(isDark),

                            SizedBox(height: 32.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Obx(
                () =>
                    controller.isLoading.value
                        ? Container(
                          color: Colors.black54,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return SizedBox(
      height: 280.h,
      child: Stack(
        children: [
          // Cover Image
          Obx(
            () => GestureDetector(
              onTap: () => ImagePickerDialog.show(context, ImageType.cover),
              child: Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.4),
                ),
                child:
                    controller.coverImage.value != null
                        ? Image.file(
                          controller.coverImage.value!,
                          fit: BoxFit.cover,
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 48.sp,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Add Cover Photo',
                              style: AppTextStyles.caption(),
                            ),
                          ],
                        ),
              ),
            ),
          ),

          // Profile Picture
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(
                () => GestureDetector(
                  onTap:
                      () => ImagePickerDialog.show(context, ImageType.profile),
                  child: Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      border: Border.all(
                        color:
                            isDark
                                ? AppColors.darkBackground
                                : AppColors.lightBackground,
                        width: 4.w,
                      ),
                    ),
                    child:
                        controller.profilePicture.value != null
                            ? ClipOval(
                              child: Image.file(
                                controller.profilePicture.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Icon(
                              Icons.add_a_photo,
                              size: 40.sp,
                              color:
                                  isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                            ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderDropdown(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w500,
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => DropdownButtonFormField<String>(
            initialValue:
                controller.selectedGender.value.isEmpty
                    ? null
                    : controller.selectedGender.value,
            hint: Text('Select gender', style: AppTextStyles.caption()),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.people,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              filled: true,
              fillColor:
                  isDark ? AppColors.darkSurface : AppColors.lightSurface,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: AppColors.primaryColor,
                  width: 2.w,
                ),
              ),
            ),
            dropdownColor:
                isDark ? AppColors.darkSurface : AppColors.lightSurface,
            style: AppTextStyles.body(),
            items:
                controller.genderOptions.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedGender.value = value;
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select gender';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationDocument(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Verification Document',
          style: AppTextStyles.caption().copyWith(
            fontWeight: FontWeight.w500,
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => GestureDetector(
            onTap:
                () => ImagePickerDialog.show(context, ImageType.verification),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
              child:
                  controller.verificationDocument.value != null
                      ? Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.green,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Document uploaded',
                              style: AppTextStyles.body(),
                            ),
                          ),
                          Icon(
                            Icons.edit,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          Icon(
                            Icons.upload_file,
                            color: AppColors.primaryColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Upload verification document',
                            style: AppTextStyles.caption(),
                          ),
                        ],
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: controller.submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Create ${controller.profileType?.value} Profile',
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:social_book/app/components/custom_text_field.dart';
// import 'package:social_book/app/components/image_picker_dialog.dart';
// import 'package:social_book/app/core/config/theme/app_colors.dart';
// import 'package:social_book/app/core/config/theme/app_text_styles.dart';
// import '../controllers/profile_registration_controller.dart';

// class ProfileRegistrationView extends GetView<ProfileRegistrationController> {
//   const ProfileRegistrationView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor:
//           isDark ? AppColors.darkBackground : AppColors.lightBackground,
//       body: Stack(
//         children: [
//           CustomScrollView(
//             slivers: [
//               // Cover & Profile Image Header
//               SliverToBoxAdapter(child: _buildHeader(context, isDark)),

//               // Form Fields
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: controller.formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomTextField(
//                           controller: controller.displayNameController,
//                           label: 'Display Name',
//                           hint: 'Enter your display name',
//                           prefixIcon: Icons.person,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter display name';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.bioController,
//                           label: 'Bio',
//                           hint: 'Tell us about yourself',
//                           prefixIcon: Icons.description,
//                           maxLines: 4,
//                         ),
//                         const SizedBox(height: 16),

//                         Obx(
//                           () => CustomTextField(
//                             controller: TextEditingController(
//                               text:
//                                   controller.dateOfBirth.value != null
//                                       ? '${controller.dateOfBirth.value!.day}/${controller.dateOfBirth.value!.month}/${controller.dateOfBirth.value!.year}'
//                                       : '',
//                             ),
//                             label: 'Date of Birth',
//                             hint: 'Select date of birth',
//                             prefixIcon: Icons.calendar_today,
//                             readOnly: true,
//                             onTap: () => controller.selectDateOfBirth(context),
//                             validator: (value) {
//                               if (controller.dateOfBirth.value == null) {
//                                 return 'Please select date of birth';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         Obx(
//                           () => CustomTextField(
//                             controller: TextEditingController(
//                               text:
//                                   controller.timeOfBirth.value != null
//                                       ? controller.timeOfBirth.value!.format(
//                                         context,
//                                       )
//                                       : '',
//                             ),
//                             label: 'Time of Birth',
//                             hint: 'Select time of birth',
//                             prefixIcon: Icons.access_time,
//                             readOnly: true,
//                             onTap: () => controller.selectTimeOfBirth(context),
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.placeOfBirthController,
//                           label: 'Place of Birth',
//                           hint: 'Enter place of birth',
//                           prefixIcon: Icons.location_on,
//                         ),
//                         const SizedBox(height: 16),

//                         _buildGenderDropdown(isDark),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.cityController,
//                           label: 'City',
//                           hint: 'Enter city',
//                           prefixIcon: Icons.location_city,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.stateController,
//                           label: 'State',
//                           hint: 'Enter state',
//                           prefixIcon: Icons.map,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.countryController,
//                           label: 'Country',
//                           hint: 'Enter country',
//                           prefixIcon: Icons.flag,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.pincodeController,
//                           label: 'Pincode',
//                           hint: 'Enter pincode',
//                           prefixIcon: Icons.pin_drop,
//                           keyboardType: TextInputType.number,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.educationController,
//                           label: 'Education',
//                           hint: 'Enter education',
//                           prefixIcon: Icons.school,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.professionController,
//                           label: 'Profession',
//                           hint: 'Enter profession',
//                           prefixIcon: Icons.work,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.companyController,
//                           label: 'Company',
//                           hint: 'Enter company name',
//                           prefixIcon: Icons.business,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.websiteController,
//                           label: 'Website',
//                           hint: 'Enter website URL',
//                           prefixIcon: Icons.link,
//                           keyboardType: TextInputType.url,
//                         ),
//                         const SizedBox(height: 16),

//                         CustomTextField(
//                           controller: controller.languageController,
//                           label: 'Language',
//                           hint: 'Enter preferred language',
//                           prefixIcon: Icons.language,
//                         ),
//                         const SizedBox(height: 16),

//                         _buildVerificationDocument(context, isDark),
//                         const SizedBox(height: 32),

//                         _buildSubmitButton(isDark),
//                         const SizedBox(height: 32),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           Obx(
//             () =>
//                 controller.isLoading.value
//                     ? Container(
//                       color: Colors.black54,
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: AppColors.primaryColor,
//                         ),
//                       ),
//                     )
//                     : const SizedBox.shrink(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, bool isDark) {
//     return SizedBox(
//       height: 280,
//       child: Stack(
//         children: [
//           // Cover Image
//           Obx(
//             () => GestureDetector(
//               onTap: () => ImagePickerDialog.show(context, ImageType.cover),
//               child: Container(
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color:
//                       isDark
//                           ? AppColors.darkBackground
//                           : AppColors.lightBackground,
//                 ),
//                 child:
//                     controller.coverImage.value != null
//                         ? Image.file(
//                           controller.coverImage.value!,
//                           fit: BoxFit.cover,
//                         )
//                         : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.add_photo_alternate,
//                               size: 48,
//                               color:
//                                   isDark
//                                       ? const Color(0xFFBDBDBD)
//                                       : const Color(0xFF757575),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Add Cover Photo',
//                               style: TextStyle(
//                                 color:
//                                     isDark
//                                         ? const Color(0xFFBDBDBD)
//                                         : const Color(0xFF757575),
//                               ),
//                             ),
//                           ],
//                         ),
//               ),
//             ),
//           ),

//           // Profile Picture
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Obx(
//                 () => GestureDetector(
//                   onTap:
//                       () => ImagePickerDialog.show(context, ImageType.profile),
//                   child: Container(
//                     width: 140,
//                     height: 140,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color:
//                           isDark
//                               ? AppColors.darkBackground
//                               : AppColors.lightBackground,
//                       border: Border.all(
//                         color:
//                             isDark
//                                 ? const Color(0xFF121212)
//                                 : const Color(0xFFF5F5F5),
//                         width: 4,
//                       ),
//                     ),
//                     child:
//                         controller.profilePicture.value != null
//                             ? ClipOval(
//                               child: Image.file(
//                                 controller.profilePicture.value!,
//                                 fit: BoxFit.cover,
//                               ),
//                             )
//                             : Icon(
//                               Icons.add_a_photo,
//                               size: 40,
//                               color:
//                                   isDark
//                                       ? const Color(0xFFBDBDBD)
//                                       : const Color(0xFF757575),
//                             ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGenderDropdown(bool isDark) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Gender',
//           style: AppTextStyles.body().copyWith(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Obx(
//           () => DropdownButtonFormField<String>(
//             value:
//                 controller.selectedGender.value.isEmpty
//                     ? null
//                     : controller.selectedGender.value,
//             hint: Text(
//               'Select gender',
//               style: TextStyle(
//                 color:
//                     isDark ? const Color(0xFFBDBDBD) : const Color(0xFF757575),
//               ),
//             ),
//             decoration: InputDecoration(
//               prefixIcon: const Icon(
//                 Icons.people,
//                 color: Color(0xFF677CE8),
//                 size: 20,
//               ),
//               filled: true,
//               fillColor:
//                   isDark ? AppColors.darkBackground : AppColors.lightBackground,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color:
//                       isDark
//                           ? AppColors.darkBackground
//                           : AppColors.lightBackground,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color:
//                        isDark ? AppColors.darkBackground : AppColors.lightBackground,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide:  BorderSide(
//                   color: AppColors.primaryColor,
//                   width: 2,
//                 ),
//               ),
//             ),
//             dropdownColor:  isDark ? AppColors.darkBackground : AppColors.lightBackground,
//             style: TextStyle(
//               color:   isDark ? AppColors.darkBackground : AppColors.lightBackground
//             ),
//             items:
//                 controller.genderOptions.map((gender) {
//                   return DropdownMenuItem<String>(
//                     value: gender,
//                     child: Text(gender),
//                   );
//                 }).toList(),
//             onChanged: (value) {
//               if (value != null) {
//                 controller.selectedGender.value = value;
//               }
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'Please select gender';
//               }
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildVerificationDocument(BuildContext context, bool isDark) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Verification Document',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w500,

//           ),
//         ),
//         const SizedBox(height: 8),
//         Obx(
//           () => GestureDetector(
//             onTap:
//                 () => ImagePickerDialog.show(context, ImageType.verification),
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color:
//                       isDark
//                           ? const Color(0xFF2C2C2C)
//                           : const Color(0xFFE0E0E0),
//                 ),
//               ),
//               child:
//                   controller.verificationDocument.value != null
//                       ? Row(
//                         children: [
//                           const Icon(
//                             Icons.check_circle,
//                             color: Color(0xFF4CAF50),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               'Document uploaded',
//                               style: TextStyle(
//                                 color:
//                                     isDark
//                                         ? Colors.white
//                                         : const Color(0xFF212121),
//                               ),
//                             ),
//                           ),
//                           const Icon(
//                             Icons.edit,
//                             color: Color(0xFF677CE8),
//                             size: 20,
//                           ),
//                         ],
//                       )
//                       : Row(
//                         children: [
//                           const Icon(
//                             Icons.upload_file,
//                             color: Color(0xFF677CE8),
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             'Upload verification document',
//                             style: TextStyle(
//                               color:
//                                   isDark
//                                       ? const Color(0xFFBDBDBD)
//                                       : const Color(0xFF757575),
//                             ),
//                           ),
//                         ],
//                       ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSubmitButton(bool isDark) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: controller.submitProfile,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF677CE8),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//         ),
//         child: const Text(
//           'Create Profile',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//         ),
//       ),
//     );
//   }
// }
