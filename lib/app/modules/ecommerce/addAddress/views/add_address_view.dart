import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/custom_text_field.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import '../controllers/add_address_controller.dart';

class AddAddressView extends GetView<AddAddressController> {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAddressController>(
      init: AddAddressController(),
      builder: (controller) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: _buildAppBar(controller, isDark),
          body: _buildForm(controller, isDark),
        );
      },
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(
    AddAddressController controller,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 70.h,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.headerGradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.white,
            size: 18.sp,
          ),
        ),
        onPressed: () => Get.back(),
      ),
      centerTitle: true,
      title: Obx(() {
        return Column(
          children: [
            Text(
              controller.isEditMode.value ? 'Edit Address' : 'Add New Address',
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              controller.isEditMode.value
                  ? 'Update your delivery address'
                  : 'Enter delivery details',
              style: AppTextStyles.small().copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 12.sp,
              ),
            ),
          ],
        );
      }),
    );
  }

  // Form
  Widget _buildForm(AddAddressController controller, bool isDark) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(controller, isDark),
            SizedBox(height: 24.h),

            // Personal Information Section
            _buildSectionHeader(
              'Personal Information',
              Icons.person_outline,
              isDark,
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.fullNameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefixIcon: Icons.person,
              keyboardType: TextInputType.name,
              validator: controller.validateName,
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.mobileController,
              label: 'Mobile Number',
              hint: 'Enter 10 digit mobile number',
              prefixIcon: Icons.phone,
              maxLength: 10,
              keyboardType: TextInputType.phone,
              validator: controller.validateMobile,
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.emailController,
              label: 'Email Address',
              hint: 'Enter your email',
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: controller.validateEmail,
            ),

            SizedBox(height: 32.h),

            // Address Details Section
            _buildSectionHeader(
              'Address Details',
              Icons.location_on_outlined,
              isDark,
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.houseNoController,
              label: 'House/Flat Number',
              hint: 'e.g., 45-B',
              prefixIcon: Icons.home,
              validator:
                  (v) => controller.validateRequired(v, 'House/Flat number'),
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.addressLine1Controller,
              label: 'Street Address',
              hint: 'House No, Street Name',
              prefixIcon: Icons.location_city,
              maxLines: 2,
              validator:
                  (v) => controller.validateRequired(v, 'Street address'),
            ),
            SizedBox(height: 16.h),

            CustomTextField(
              controller: controller.landmarkController,
              label: 'Landmark (Optional)',
              hint: 'Nearby landmark',
              prefixIcon: Icons.place,
            ),

            SizedBox(height: 32.h),

            // Location Section
            _buildSectionHeader('Location', Icons.map_outlined, isDark),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.cityController,
                    label: 'City',
                    hint: 'Enter city',
                    prefixIcon: Icons.location_city,
                    validator: (v) => controller.validateRequired(v, 'City'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomTextField(
                    controller: controller.stateController,
                    label: 'State',
                    hint: 'Enter state',
                    prefixIcon: Icons.map,
                    validator: (v) => controller.validateRequired(v, 'State'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.pincodeController,
                    label: 'Pincode',
                    hint: '6 digit code',
                    prefixIcon: Icons.pin_drop,
                    keyboardType: TextInputType.number,
                    validator: controller.validatePincode,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: CustomTextField(
                    controller: controller.countryController,
                    label: 'Country',
                    hint: 'India',
                    prefixIcon: Icons.flag,
                    readOnly: false,
                    validator: (v) => controller.validateRequired(v, 'Country'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            // Save Button
            _buildSaveButton(controller, isDark),

            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  // Header Card
  Widget _buildHeaderCard(AddAddressController controller, bool isDark) {
    return Obx(() {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        builder: (context, double value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withValues(alpha: 0.1),
                AppColors.accentColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.headerGradientColors,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  controller.isEditMode.value
                      ? Icons.edit_location_alt
                      : Icons.add_location_alt,
                  color: AppColors.white,
                  size: 32.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.isEditMode.value
                          ? 'Update Address'
                          : 'New Delivery Address',
                      style: AppTextStyles.body().copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color:
                            isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      controller.isEditMode.value
                          ? 'Modify your existing address details'
                          : 'Fill in the details for delivery',
                      style: AppTextStyles.small().copyWith(
                        color:
                            isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                        fontSize: 12.sp,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Section Header
  Widget _buildSectionHeader(String title, IconData icon, bool isDark) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(-20 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Text(
            title,
            style: AppTextStyles.headlineMedium().copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color:
                  isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Save Button
  Widget _buildSaveButton(AddAddressController controller, bool isDark) {
    return Obx(() {
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, double value, child) {
          return Transform.scale(scale: 0.9 + (0.1 * value), child: child);
        },
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.headerGradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withValues(alpha: 0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed:
                controller.isLoading.value
                    ? null
                    : () => controller.saveAddress(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: controller.isLoading.value? CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth:2.w,
            ):Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isEditMode.value
                      ? Icons.update
                      : Icons.add_location_alt,
                  size: 24.sp,
                  color: AppColors.white,
                ),
                SizedBox(width: 12.w),
                Text(
                  controller.isEditMode.value
                      ? 'Update Address'
                      : 'Save Address',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
