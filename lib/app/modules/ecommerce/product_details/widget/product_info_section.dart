import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/product_details_model.dart';
import 'package:social_book/app/modules/ecommerce/product_details/controllers/product_details_controller.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductDetails productDetails;
  final bool isDark;

  const ProductInfoSection({
    super.key,
    required this.productDetails,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            productDetails.productName ?? 'Product Name',
            style: AppTextStyles.headlineLarge().copyWith(fontSize: 22.sp),
          ),

          SizedBox(height: 8.h),

          // Short Description
          if (productDetails.shortDescription != null)
            Text(
              productDetails.shortDescription!,
              style: AppTextStyles.body().copyWith(
                color:
                    isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
              ),
            ),

          SizedBox(height: 16.h),

          // Price Section
          Row(
            children: [
              // Selling Price
              Text(
                '\u20B9 ${controller.selectedVariant.value?.price ?? productDetails.sellingPrice?.toStringAsFixed(2) ?? '0.00'}',
                style: AppTextStyles.headlineLarge().copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.sp,
                ),
              ),

              SizedBox(width: 12.w),

              // MRP (if different from selling price)
              if (productDetails.mrp != null &&
                  productDetails.mrp! > (productDetails.sellingPrice ?? 0))
                Text(
                  '\u20B9 ${productDetails.mrp!.toStringAsFixed(2)}',
                  style: AppTextStyles.body().copyWith(
                    color:
                        isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),

              SizedBox(width: 8.w),

              // Discount Percentage
              if (productDetails.mrp != null &&
                  productDetails.sellingPrice != null &&
                  productDetails.mrp! > productDetails.sellingPrice!)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${_calculateDiscount(productDetails.mrp!, productDetails.sellingPrice!)}% OFF',
                    style: AppTextStyles.caption().copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // Stock Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    productDetails.inStock != null &&
                            productDetails.inStock! > 0
                        ? Icons.check_circle
                        : Icons.cancel,
                    color:
                        productDetails.inStock != null &&
                                productDetails.inStock! > 0
                            ? AppColors.green
                            : AppColors.red,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Obx(() {
                    final int availableStock =
                        controller.selectedVariant.value?.stock ??
                        productDetails.inStock ??
                        0;

                    final bool inStock = availableStock > 0;

                    return Text(
                      inStock
                          ? 'In Stock ($availableStock available)'
                          : 'Out of Stock',
                      style: AppTextStyles.body().copyWith(
                        color: inStock ? AppColors.green : AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }),
                ],
              ),

              Obx(() {
                final int maxStock = controller.maxStock;
                final int qty = controller.quantity.value;

                final bool canIncrease = qty < maxStock;
                final bool canDecrease = qty > 1;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color:
                          isDark
                              ? AppColors.white
                              : AppColors.darkTextSecondary,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        enabled: canDecrease,
                        onTap: controller.decreaseQty,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          qty.toString(),
                          style: AppTextStyles.body().copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      _QtyButton(
                        icon: Icons.add,
                        enabled: canIncrease,
                        onTap: controller.increaseQty,
                      ),
                    ],
                  ),
                );
              }),
            
            ],
          ),

          // SizedBox(height: 12.h),

          // Rating Section (Placeholder - can be added later)
          // Row(
          //   children: [
          //     Icon(Icons.star, color: AppColors.yellow, size: 20.sp),
          //     SizedBox(width: 4.w),
          //     Text(
          //       '4.5',
          //       style: AppTextStyles.body().copyWith(
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //     SizedBox(width: 4.w),
          //     Text('(128 reviews)', style: AppTextStyles.caption()),
          //   ],
          // ),
        ],
      ),
    );
  }

  int _calculateDiscount(double mrp, double sellingPrice) {
    if (mrp <= 0) return 0;
    return (((mrp - sellingPrice) / mrp) * 100).round();
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? theme.colorScheme.primary : theme.disabledColor,
        ),
      ),
    );
  }
}
