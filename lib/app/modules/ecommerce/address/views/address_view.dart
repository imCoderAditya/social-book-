import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/address_model.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/address_controller.dart';

class AddressView extends GetView<AddressController> {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddressController>(
      init: AddressController(),
      builder: (controller) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: _buildAppBar(isDark),
          body: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState(isDark);
            }

            if (controller.addressModel.value?.addressData?.isEmpty ?? true) {
              return _buildEmptyState(isDark);
            }

            return _buildAddressList(controller, isDark);
          }),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
            child: _buildAddButton(isDark),
          ),
        );
      },
    );
  }

  // Gradient App Bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      elevation: 0,
      toolbarHeight: 60.h,
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
            borderRadius: BorderRadius.circular(10.r),
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
      title: Column(
        children: [
          Text(
            'Delivery Addresses',
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Obx(() {
            final controller = Get.find<AddressController>();
            final total = controller.addressModel.value?.total ?? 0;
            if (total > 0) {
              return Text(
                '$total ${total == 1 ? 'Address' : 'Addresses'} Saved',
                style: AppTextStyles.small().copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                  fontSize: 12.sp,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final value = await Get.toNamed(Routes.ADD_ADDRESS);
            if (value == true) {
              await controller.fetchAddress();
            }
          },
          child: Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, color: AppColors.white),
                const SizedBox(width: 4),
                Text(
                  'Location',
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Loading State
  Widget _buildLoadingState(bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkDivider
                              : AppColors.lightDivider,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 12.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? AppColors.darkDivider
                                    : AppColors.lightDivider,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Empty State
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(40.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryColor.withValues(alpha: 0.1),
                            AppColors.accentColor.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 80.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
              Text(
                'No Address Found',
                style: AppTextStyles.headlineMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Add a delivery address to get\nyour orders delivered',
                textAlign: TextAlign.center,
                style: AppTextStyles.body().copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 8.h),
              MaterialButton(
                shape: RoundedSuperellipseBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                onPressed: () async {
                  final value = await Get.toNamed(Routes.ADD_ADDRESS);
                  if (value == true) {
                    await controller.fetchAddress();
                  }
                },
                color: AppColors.primaryColor,
                child: Text("Add Address", style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Address List
  Widget _buildAddressList(AddressController controller, bool isDark) {
    return Column(
      children: [
        // Info Banner
        Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryColor.withValues(alpha: 0.1),
                AppColors.accentColor.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Select an address for delivery',
                  style: AppTextStyles.body().copyWith(
                    fontSize: 14.sp,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Address Cards
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.addressModel.value?.addressData?.length ?? 0,
            itemBuilder: (context, index) {
              final address =
                  controller.addressModel.value?.addressData?[index];
              return _buildAddressCard(controller, address!, index, isDark);
            },
          ),
        ),
      ],
    );
  }

  // Address Card with Selection and Delete
  Widget _buildAddressCard(
    AddressController controller,
    AddressData address,
    int index,
    bool isDark,
  ) {
    final isSelected = controller.selectAddressData.value == address;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          controller.selectAddress(addressData: address);
        },
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color:
                    isSelected
                        ? AppColors.primaryColor.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.05),
                blurRadius: isSelected ? 15 : 10,
                offset: Offset(0, isSelected ? 6 : 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Selected gradient overlay
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withValues(alpha: 0.05),
                          AppColors.accentColor.withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),

              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        // Address Type Icon
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors:
                                  isSelected
                                      ? AppColors.headerGradientColors
                                      : [
                                        AppColors.lightDivider,
                                        AppColors.lightDivider,
                                      ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            _getAddressIcon(address),
                            color:
                                isSelected
                                    ? AppColors.white
                                    : AppColors.lightTextSecondary,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Name and Phone
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.fullName ?? '',
                                style: AppTextStyles.body().copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color:
                                      isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 14.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    address.mobileNo ?? '',
                                    style: AppTextStyles.small().copyWith(
                                      color:
                                          isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Selection Radio
                        Container(
                          padding: EdgeInsets.all(4.w),
                          margin: EdgeInsets.only(top: 10.h),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : (isDark
                                          ? AppColors.darkDivider
                                          : AppColors.lightDivider),
                              width: 2,
                            ),
                          ),
                          child: Container(
                            width: 16.w,
                            height: 16.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  isSelected
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                            ),
                            child:
                                isSelected
                                    ? Icon(
                                      Icons.check,
                                      size: 12.sp,
                                      color: AppColors.white,
                                    )
                                    : null,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Divider
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            (isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Address Details
                    _buildAddressDetail(
                      Icons.home_outlined,
                      '${address.houseandFlatNo}, ${address.addressLine1}',
                      isDark,
                    ),

                    if (address.landmark != null &&
                        address.landmark!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      _buildAddressDetail(
                        Icons.location_on_outlined,
                        'Near ${address.landmark}',
                        isDark,
                      ),
                    ],

                    SizedBox(height: 8.h),
                    _buildAddressDetail(
                      Icons.place_outlined,
                      '${address.city}, ${address.state} - ${address.pincode}',
                      isDark,
                    ),

                    SizedBox(height: 16.h),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.edit_outlined,
                            label: 'Edit',
                            onTap: () {
                              Get.toNamed(
                                Routes.ADD_ADDRESS,
                                arguments: address,
                              )?.then((value) async {
                                await controller.fetchAddress();
                              });
                            },
                            isDark: isDark,
                            isPrimary: false,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: _buildActionButton(
                            icon: Icons.delete_outline_rounded,
                            label: 'Delete',
                            onTap: () {
                              _showDeleteDialog(controller, address, isDark);
                            },
                            isDark: isDark,
                            isPrimary: false,
                            isDelete: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Selected Badge
              if (isSelected)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomLeft: Radius.circular(12.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Selected',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Address Detail Row
  Widget _buildAddressDetail(IconData icon, String text, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: AppColors.primaryColor.withValues(alpha: 0.7),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body().copyWith(
              fontSize: 14.sp,
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // Action Button
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
    bool isPrimary = false,
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isDelete
                  ? AppColors.red.withValues(alpha: 0.1)
                  : (isDark
                      ? AppColors.darkDivider
                      : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isDelete
                    ? AppColors.red.withValues(alpha: 0.3)
                    : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isDelete ? AppColors.red : AppColors.primaryColor,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: AppTextStyles.body().copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDelete ? AppColors.red : AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Floating Add Button
  Widget _buildAddButton(bool isDark) {
    return Obx(
      () =>
          (controller.selectAddressData.value == null &&
                  (controller.addressModel.value?.addressData?.isEmpty ?? true))
              ? SizedBox()
              : Container(
                width: double.infinity,
                height: 45.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.headerGradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Get.offNamed(
                      Routes.SUMMARY,
                      arguments: {
                        "cartData": controller.cartModel.value,
                        "address": controller.selectAddressData.value,
                      },
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  icon: Icon(
                    Icons.next_plan,
                    size: 24.sp,
                    color: AppColors.white,
                  ),
                  label: Text(
                    'Next',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
    );
  }

  // Delete Dialog
  void _showDeleteDialog(
    AddressController controller,
    AddressData address,
    bool isDark,
  ) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_outlined,
                  size: 48.sp,
                  color: AppColors.red,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                'Delete Address?',
                style: AppTextStyles.headlineMedium().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                  color:
                      isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                ),
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                'Are you sure you want to delete this address? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body().copyWith(
                  fontSize: 14.sp,
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              // Buttons
              Obx(() {
                return controller.isLoadingDelete.value
                    ? Transform.scale(
                      scale: 0.8,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryColor,
                      ),
                    )
                    : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isDark
                                      ? AppColors.darkDivider
                                      : AppColors.lightBackground,
                              foregroundColor:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTextStyles.button.copyWith(
                                color:
                                    isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await controller.deleteAddress(
                                address.addressId ?? 0,
                              );
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.red,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: AppTextStyles.button.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Get appropriate icon for address
  IconData _getAddressIcon(AddressData address) {
    final addressLower = (address.addressLine1 ?? '').toLowerCase();
    if (addressLower.contains('home') || addressLower.contains('house')) {
      return Icons.home;
    } else if (addressLower.contains('office') ||
        addressLower.contains('work')) {
      return Icons.business;
    } else if (addressLower.contains('hotel') ||
        addressLower.contains('resort')) {
      return Icons.hotel;
    }
    return Icons.location_on;
  }
}
