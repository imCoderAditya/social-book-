// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/modules/ecommerce/product_details/widget/color_selector.dart';
import 'package:social_book/app/modules/ecommerce/product_details/widget/product_details_shimmer.dart';
import 'package:social_book/app/modules/ecommerce/product_details/widget/product_info_section.dart'
    show ProductInfoSection;
import 'package:social_book/app/modules/ecommerce/product_details/widget/variant_selector.dart';
import 'package:social_book/app/modules/ecommerce/widgets/cart_badge_icon.dart';
import 'package:social_book/app/modules/widget/product_image_carousel.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<ProductDetailsController>(
      init: ProductDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: Obx(() {
            if (controller.isLoading.value) {
              return ProductShimmer(isDark: isDark);
            }

            final productDetails =
                controller.productDetailsModel.value?.productDetails;
            if (productDetails == null) {
              return Center(
                child: Text('Product not found', style: AppTextStyles.body()),
              );
            }

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  expandedHeight: 60.h,
                  floating: true,
                  pinned: true,
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.white),
                    onPressed: () => Get.back(),
                  ),
                  actions: [CartBadgeIcon()],
                ),

                // Product Images Carousel
                SliverToBoxAdapter(
                  child: Obx(() {
                    final selectedColor = controller.selectedColor.value;

                    List<String> images = [];

                    if (selectedColor != null && selectedColor.images != null) {
                      images = selectedColor.images!;
                    } else if (productDetails.image != null) {
                      images = [productDetails.image!];
                    }

                    return ProductImageCarousel(images: images, isDark: isDark);
                  }),
                ),

                // Product Info Section
                SliverToBoxAdapter(
                  child: ProductInfoSection(
                    productDetails: productDetails,
                    isDark: isDark,
                  ),
                ),

                // Variants (Size Selector)
                if (productDetails.variants != null &&
                    productDetails.variants!.isNotEmpty)
                  SliverToBoxAdapter(
                    child: VariantSelector(
                      variants: productDetails.variants!,
                      selectedVariant: controller.selectedVariant.value,
                      onVariantSelected: (variant) {
                        controller.selectVariant(variant);
                      },
                      isDark: isDark,
                    ),
                  ),

                // Color Selector
                SliverToBoxAdapter(
                  child: Obx(() {
                    final selectedVariant = controller.selectedVariant.value;
                    if (selectedVariant?.colors != null &&
                        selectedVariant!.colors!.isNotEmpty) {
                      return ColorSelector(
                        colors: selectedVariant.colors!,
                        selectedColor: controller.selectedColor.value,
                        onColorSelected: (color) {
                          controller.selectColor(color);
                        },
                        isDark: isDark,
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ),

                // Description Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: AppTextStyles.headlineMedium(),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          productDetails.description ??
                              'No description available',
                          style: AppTextStyles.body().copyWith(
                            color:
                                isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Product Details Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color:
                            isDark
                                ? AppColors.darkSurface
                                : AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Details',
                            style: AppTextStyles.headlineMedium(),
                          ),
                          SizedBox(height: 16.h),
                          _buildDetailRow(
                            'Category',
                            productDetails.categoryName ?? 'N/A',
                            isDark,
                          ),
                          _buildDetailRow(
                            'Weight',
                            '${productDetails.weight ?? 0} kg',
                            isDark,
                          ),
                          _buildDetailRow(
                            'Dimensions',
                            '${productDetails.length ?? 0} x ${productDetails.width ?? 0} x ${productDetails.height ?? 0} cm',
                            isDark,
                          ),
                          _buildDetailRow(
                            'Shipping Charges',
                            '\u20B9 ${productDetails.shippingCharges ?? 0}',
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 100.h)),
              ],
            );
          }),

          // Bottom Add to Cart Bar
          bottomNavigationBar: Obx(() {
            if (controller.isLoading.value) return const SizedBox.shrink();

            final productDetails =
                controller.productDetailsModel.value?.productDetails;
            if (productDetails == null) return const SizedBox.shrink();

            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price', style: AppTextStyles.caption()),
                        SizedBox(height: 4.h),
                        Obx(() {
                          final selectedVariant =
                              controller.selectedVariant.value;
                          final price =
                              selectedVariant?.price ??
                              productDetails.sellingPrice ??
                              0;

                          return Text(
                            '\u20B9 ${price.toStringAsFixed(2)}',
                            style: AppTextStyles.headlineMedium().copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                      ],
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.headerGradientColors,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Obx(() {
                          return ElevatedButton(
                            onPressed: () {
                              // Add to cart logic
                              controller.addToCart();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child:
                                controller.isLoadingAddTocart.value
                                    ? Transform.scale(
                                      scale: 0.8,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 0.9,
                                        color: AppColors.white,
                                      ),
                                    )
                                    : Text(
                                      'Add to Cart',
                                      style: AppTextStyles.button,
                                    ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body().copyWith(
              color:
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body().copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
