import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/cart_model.dart';
import '../controllers/summary_controller.dart';

class SummaryView extends GetView<SummaryController> {
  const SummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SummaryController>(
      init: SummaryController(),
      builder: (controller) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
          appBar: _buildAppBar(isDark),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Delivery Address Card
                _buildDeliveryAddressCard(controller, isDark),
                
                // Order Items
                _buildOrderItems(controller, isDark),
                
                // Payment Method
                _buildPaymentMethod(controller, isDark),
                
                // Price Details
                _buildPriceDetails(controller, isDark),
                
                // Terms and Conditions
                _buildTermsCheckbox(controller, isDark),
                
                SizedBox(height: 100.h), // Space for bottom button
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomBar(controller, isDark),
        );
      },
    );
  }

  // App Bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
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
            color: Colors.white.withValues(alpha:0.2),
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
      title: Column(
        children: [
          Text(
            'Order Summary',
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'Review your order',
            style: AppTextStyles.small().copyWith(
              color: AppColors.white.withValues(alpha:0.9),
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Delivery Address Card
  Widget _buildDeliveryAddressCard(SummaryController controller, bool isDark) {
    return Obx(() {
      final address = controller.deliveryAddress.value;
      
      return Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha:0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha:0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.headerGradientColors,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Address',
                        style: AppTextStyles.body().copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Estimated: ${controller.getEstimatedDelivery()}',
                        style: AppTextStyles.small().copyWith(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back(); // Go back to change address
                  },
                  child: Text(
                    'Change',
                    style: AppTextStyles.body().copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              height: 1,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
            SizedBox(height: 12.h),
            if (address != null) ...[
              Text(
                address.fullName ?? '',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
              SizedBox(height: 6.h),
              Row(
                children: [
                  Icon(Icons.phone, size: 14.sp, color: AppColors.primaryColor),
                  SizedBox(width: 6.w),
                  Text(
                    address.mobileNo ?? '',
                    style: AppTextStyles.body().copyWith(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '${address.houseandFlatNo}, ${address.addressLine1}',
                style: AppTextStyles.body().copyWith(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${address.city}, ${address.state} - ${address.pincode}',
                style: AppTextStyles.body().copyWith(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  // Order Items
  Widget _buildOrderItems(SummaryController controller, bool isDark) {
    return Obx(() {
      final items = controller.cartModel.value?.cartData ?? [];
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Order Items (${items.length})',
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(
                  height: 1,
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                ),
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildOrderItem(item, isDark);
              },
            ),
          ],
        ),
      );
    });
  }

  // Individual Order Item
  Widget _buildOrderItem(CartData item, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: item.productImage ?? '',
            width: 70.w,
            height: 70.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 70.w,
              height: 70.h,
              color: AppColors.lightDivider,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 70.w,
              height: 70.h,
              color: AppColors.lightDivider,
              child: Icon(Icons.image, size: 30.sp),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        
        // Product Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productName ?? '',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              if (item.size != null || item.color != null)
                Wrap(
                  spacing: 6.w,
                  children: [
                    if (item.size != null)
                      _buildVariantChip('Size: ${item.size}', isDark),
                    if (item.color != null)
                      _buildVariantChip('Color: ${item.color}', isDark),
                  ],
                ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${item.qty}',
                    style: AppTextStyles.body().copyWith(
                      fontSize: 13.sp,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    '₹${item.totalSell?.toStringAsFixed(0) ?? '0'}',
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Variant Chip
  Widget _buildVariantChip(String label, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.darkDivider 
            : AppColors.primaryColor.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.small().copyWith(
          fontSize: 11.sp,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Payment Method Selection
  Widget _buildPaymentMethod(SummaryController controller, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payment,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Payment Method',
                style: AppTextStyles.body().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          Obx(() {
            return Column(
              children: [
                // COD Option
                _buildPaymentOption(
                  controller,
                  PaymentMethod.cod,
                  '💵',
                  'Cash on Delivery',
                  'Pay when you receive',
                  isDark,
                ),
                SizedBox(height: 12.h),
                
                // Online Payment Option
                _buildPaymentOption(
                  controller,
                  PaymentMethod.online,
                  '💳',
                  'Online Payment',
                  'UPI, Cards, Netbanking',
                  isDark,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  // Payment Option Card
  Widget _buildPaymentOption(
    SummaryController controller,
    PaymentMethod method,
    String emoji,
    String title,
    String subtitle,
    bool isDark,
  ) {
    final isSelected = controller.selectedPaymentMethod.value == method;
    
    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(method),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha:0.1)
              : (isDark ? AppColors.darkDivider : AppColors.lightBackground),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryColor 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor.withValues(alpha:0.2)
                    : (isDark ? AppColors.darkSurface : AppColors.white),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                emoji,
                style: TextStyle(fontSize: 24.sp),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.small().copyWith(
                      fontSize: 12.sp,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.lightDivider,
                  width: 2,
                ),
              ),
              child: Container(
                width: 14.w,
                height: 14.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryColor : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Price Details
  Widget _buildPriceDetails(SummaryController controller, bool isDark) {
    return Obx(() {
      final summary = controller.cartModel.value?.summary;
      
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor.withValues(alpha:0.05),
              AppColors.accentColor.withValues(alpha:0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha:0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Price Details',
                  style: AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            
            _buildPriceRow(
              'Subtotal',
              '₹${summary?.subTotal?.toStringAsFixed(2) ?? '0.00'}',
              isDark,
            ),
            SizedBox(height: 10.h),
            _buildPriceRow(
              'Shipping Charge',
              summary?.shippingCharge == 0 
                  ? 'FREE' 
                  : '₹${summary?.shippingCharge?.toStringAsFixed(2) ?? '0.00'}',
              isDark,
              isFree: summary?.shippingCharge == 0,
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(
                height: 1,
                color: AppColors.primaryColor.withValues(alpha:0.3),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: AppTextStyles.headlineMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                Text(
                  '₹${summary?.grandTotal?.toStringAsFixed(2) ?? '0.00'}',
                  style: AppTextStyles.headlineMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // Price Row
  Widget _buildPriceRow(String label, String value, bool isDark, {bool isFree = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.body().copyWith(
            fontSize: 14.sp,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.body().copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
            color: isFree 
                ? AppColors.green 
                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }

  // Terms Checkbox
  Widget _buildTermsCheckbox(SummaryController controller, bool isDark) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: controller.agreedToTerms.value,
              onChanged: (value) => controller.toggleTermsAgreement(),
              activeColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: RichText(
                  text: TextSpan(
                    text: 'I agree to the ',
                    style: AppTextStyles.body().copyWith(
                      fontSize: 13.sp,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms & Conditions',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Bottom Bar with Place Order Button
  Widget _buildBottomBar(SummaryController controller, bool isDark) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment Method Summary
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.getPaymentMethodIcon(),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      controller.getPaymentMethodText(),
                      style: AppTextStyles.body().copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              
              // Place Order Button
              Container(
                width: double.infinity,
                height: 45.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: controller.isPlacingOrder.value
                        ? [AppColors.lightDivider, AppColors.lightDivider]
                        : AppColors.headerGradientColors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: controller.isPlacingOrder.value
                      ? []
                      : [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(alpha:0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                ),
                child: ElevatedButton(
                  onPressed: controller.isPlacingOrder.value 
                      ? null 
                      : () => controller.placeOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: controller.isPlacingOrder.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Placing Order...',
                              style: AppTextStyles.button.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 24.sp,color: AppColors.white,),
                            SizedBox(width: 12.w),
                            Text(
                              'Place Order',
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
            ],
          ),
        ),
      );
    });
  }
}