import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/cart_model.dart';
import 'package:social_book/app/modules/ecommerce/cart/controllers/cart_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final controller = Get.put(CartController());

  @override
  void initState() {
    controller.fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          extendBodyBehindAppBar: false,
          appBar: _buildAppBar(controller, isDark),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                controller.isLoading.value
                    ? _buildLoadingState()
                    : controller.cartModel.value?.cartData?.isEmpty ?? true
                    ? _buildEmptyCart(isDark)
                    : _buildCartContent(controller, isDark),
          ),
          bottomNavigationBar:
              controller.cartModel.value?.cartData?.isNotEmpty ?? false
                  ? _buildBottomSummary(controller, isDark)
                  : null,
        );
      },
    );
  }

  // Modern App Bar with gradient
  PreferredSizeWidget _buildAppBar(CartController controller, bool isDark) {
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
      title: Column(
        children: [
          Text(
            'Shopping Cart',
            style: AppTextStyles.headlineMedium().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (controller.cartModel.value?.cartData?.isNotEmpty ?? false)
            Text(
              '${controller.cartModel.value?.totalItems} ${(controller.cartModel.value?.totalItems ?? 0) == 1 ? 'Item' : 'Items'}',
              style: AppTextStyles.small().copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
                fontSize: 12.sp,
              ),
            ),
        ],
      ),
    );
  }

  Color _shimmerBaseColor(bool isDark) {
    return isDark
        ? AppColors.darkTextSecondary.withValues(alpha: 0.5)
        : AppColors.lightTextSecondary.withValues(alpha: 0.4);
  }

  Color _shimmerHighlightColor(bool isDark) {
    return isDark ? AppColors.white.withValues(alpha: 0.25) : AppColors.white;
  }

  // Loading state with shimmer effect
  Widget _buildLoadingState() {
    final isDark = Theme.of(Get.context!).brightness == Brightness.dark;

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: _shimmerBaseColor(isDark),
          highlightColor: _shimmerHighlightColor(isDark),
          period: const Duration(milliseconds: 1200),
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                // Image placeholder
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: _shimmerBaseColor(isDark),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 12.w),

                // Text placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _shimmerBaseColor(isDark),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        height: 12.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: _shimmerBaseColor(isDark),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Empty cart with illustration
  Widget _buildEmptyCart(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated empty cart icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: EdgeInsets.all(32.w),
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
                        Icons.shopping_cart_outlined,
                        size: 100.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
              Text(
                'Your cart is empty',
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
                'Looks like you haven\'t added\nanything to your cart yet',
                textAlign: TextAlign.center,
                style: AppTextStyles.body().copyWith(
                  color:
                      isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40.h),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.headerGradientColors,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 48.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storefront, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Start Shopping',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 16.sp,
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

  // Cart content with enhanced design
  Widget _buildCartContent(CartController controller, bool isDark) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      itemCount: controller.cartModel.value?.cartData?.length ?? 0,
      itemBuilder: (context, index) {
        final item = controller.cartModel.value?.cartData?[index];
        return _buildEnhancedCartItem(controller, item!, index, isDark);
      },
    );
  }

  // Enhanced cart item card
  Widget _buildEnhancedCartItem(
    CartController controller,
    CartData item,
    int index,
    bool isDark,
  ) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Navigate to product details
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image with badge
                    Stack(
                      children: [
                        Hero(
                          tag: 'product_${item.productId}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: CachedNetworkImage(
                                imageUrl: item.productImage ?? '',
                                width: 90.w,
                                height: 90.h,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      width: 90.w,
                                      height: 90.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.lightDivider,
                                            AppColors.lightDivider.withValues(
                                              alpha: 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      width: 90.w,
                                      height: 90.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.lightDivider,
                                            AppColors.lightDivider.withValues(
                                              alpha: 0.5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 32.sp,
                                        color: AppColors.lightTextSecondary,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        ),
                        // Stock badge
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.green,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              'In Stock',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),

                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName ?? '',
                            style: AppTextStyles.body().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color:
                                  isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),

                          // Variant info
                          if (item.size != null || item.color != null)
                            Wrap(
                              spacing: 6.w,
                              runSpacing: 6.h,
                              children: [
                                if (item.size != null)
                                  _buildVariantChip(
                                    icon: Icons.straighten,
                                    label: item.size!,
                                    isDark: isDark,
                                  ),
                                if (item.color != null)
                                  _buildVariantChip(
                                    icon: Icons.palette_outlined,
                                    label: item.color!,
                                    isDark: isDark,
                                  ),
                              ],
                            ),
                          SizedBox(height: 6.h),

                          // Price and quantity row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Price
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item.unitPrice != item.totalSell)
                                    Text(
                                      '₹${item.unitPrice?.toStringAsFixed(0) ?? '0'}',
                                      style: AppTextStyles.small().copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.lightTextSecondary,
                                      ),
                                    ),
                                  Text(
                                    '₹${item.totalSell?.toStringAsFixed(0) ?? '0'}',
                                    style: AppTextStyles.body().copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),

                              // Quantity controls
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Delete button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            showDeleteCartItemDialog(controller, item, isDark);
                          },
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: AppColors.red,
                              size: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        _buildQuantityControl(controller, item, isDark, index),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Variant chip widget
  Widget _buildVariantChip({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color:
            isDark
                ? AppColors.darkDivider
                : AppColors.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: AppColors.primaryColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.small().copyWith(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Quantity control widget
  Widget _buildQuantityControl(
    CartController controller,
    CartData item,
    bool isDark,
    int? index,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkDivider : AppColors.lightBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onTap: () => controller.decreaseQty(index!),
            enabled: (item.qty ?? 0) > 1,
            isDark: isDark,
          ),
          Container(
            constraints: BoxConstraints(minWidth: 32.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(
              '${item.qty ?? 0}',
              textAlign: TextAlign.center,
              style: AppTextStyles.body().copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color:
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onTap: () => controller.increaseQty(index!),
            enabled: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  // Quantity button
  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    required bool isDark,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(6.w),
        child: Icon(
          icon,
          size: 16.sp,
          color:
              enabled
                  ? AppColors.primaryColor
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
        ),
      ),
    );
  }

  // Bottom summary with enhanced design
  Widget _buildBottomSummary(CartController controller, bool isDark) {
    final summary = controller.cartModel.value?.summary;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color:
                      isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),

              // Price breakdown
              _buildPriceRow(
                'Subtotal',
                '₹${summary?.subTotal?.toStringAsFixed(2) ?? '0.00'}',
                isDark,
                isSubtitle: true,
              ),
              SizedBox(height: 12.h),
              _buildPriceRow(
                'Shipping',
                summary?.shippingCharge == 0
                    ? 'FREE'
                    : '₹${summary?.shippingCharge?.toStringAsFixed(2) ?? '0.00'}',
                isDark,
                isSubtitle: true,
                highlightFree: summary?.shippingCharge == 0,
              ),

              // Divider
              Container(
                margin: EdgeInsets.symmetric(vertical: 16.h),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Grand total
              _buildPriceRow(
                'Total',
                '₹${summary?.grandTotal?.toStringAsFixed(2) ?? '0.00'}',
                isDark,
                isTotal: true,
              ),
              SizedBox(height: 20.h),

              // Checkout button with gradient
              Container(
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
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.ADDRESS,
                      arguments: controller.cartModel.value,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Proceed to Checkout',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20.sp,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // Security badge
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 14.sp, color: AppColors.green),
                  SizedBox(width: 6.w),
                  Text(
                    'Secure Checkout',
                    style: AppTextStyles.small().copyWith(
                      color:
                          isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Price row helper
  Widget _buildPriceRow(
    String label,
    String value,
    bool isDark, {
    bool isSubtitle = false,
    bool isTotal = false,
    bool highlightFree = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style:
              isTotal
                  ? AppTextStyles.headlineMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color:
                        isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                  )
                  : AppTextStyles.body().copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    fontSize: 14.sp,
                  ),
        ),
        Text(
          value,
          style:
              isTotal
                  ? AppTextStyles.headlineMedium().copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: AppColors.primaryColor,
                  )
                  : AppTextStyles.body().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color:
                        highlightFree
                            ? AppColors.green
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                  ),
        ),
      ],
    );
  }

  // Delete Dialog
  void showDeleteCartItemDialog(
    CartController controller,
    CartData item,
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
              // 🔴 Icon
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

              // 🔴 Title
              Text(
                'Remove Item?',
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

              // 🔴 Message
              Text(
                'Are you sure you want to remove "${item.productName ?? "this item"}" from cart?',
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

              // 🔴 Buttons / Loader
              Obx(() {
                if (controller.isLoading.value) {
                  return Transform.scale(
                    scale: 0.8,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  );
                }

                return Row(
                  children: [
                    // Cancel
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
                            fontWeight: FontWeight.w600,
                            color:
                                isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Delete
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.deleteItemAPI(cartId: item.id);
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
                          'Remove',
                          style: AppTextStyles.button.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
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
}
