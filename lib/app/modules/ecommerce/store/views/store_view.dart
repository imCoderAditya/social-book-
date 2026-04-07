// // ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/data/models/ecommerce/product_model.dart';
import 'package:social_book/app/modules/ecommerce/widgets/cart_badge_icon.dart';
import 'package:social_book/app/routes/app_pages.dart';
import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GetBuilder<StoreController>(
      init: StoreController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          body: CustomScrollView(
            controller: controller.scrollProductController,
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 140.h,
                floating: false,
                pinned: true,
                backgroundColor: Colors.black.withValues(alpha: 0.2),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: AppColors.headerGradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Discover',
                              style: AppTextStyles.headlineLarge().copyWith(
                                color: Colors.white,
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Find your perfect products',
                              style: AppTextStyles.subtitle().copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [CartBadgeIcon()],
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? AppColors.darkSurface
                              : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      // 1. Controller attach karein (taki clear karne par text gayab ho jaye)
                      controller: controller.searchEditController,

                      onChanged: (value) {
                        // 2. Sirf method call karein, debounce controller handle kar lega
                        controller.updateSearch(value);
                      },

                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: AppTextStyles.body().copyWith(
                          color:
                              isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.primaryColor,
                        ),

                        // 3. Clear button: Sirf tab dikhega jab user ne kuch likha ho
                        suffixIcon: Obx(
                          () =>
                              controller.searchQuery.value.isEmpty
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      controller.searchEditController
                                          .clear(); // UI se text hatayega
                                      controller.updateSearch(
                                        '',
                                      ); // API ko update karega
                                    },
                                  ),
                        ),

                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Categories
              // Categories
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'Categories',
                        style: AppTextStyles.headlineMedium(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(() {
                      if (controller.isCategoryLoading.value) {
                        return _CategoryShimmer(isDark: isDark);
                      }
                      return SizedBox(
                        height: 100.h,
                        child: ListView.builder(
                          controller: controller.scrollCategoryController,
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          itemCount:
                              controller.categoriesList.length +
                              (controller.isCategoryLoadingMore.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Last item pe loading indicator
                            if (index == controller.categoriesList.length) {
                              return Obx(() {
                                if (controller.isCategoryLoadingMore.value) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      child: SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              });
                            }

                            final category = controller.categoriesList[index];

                            return GestureDetector(
                              onTap: () {
                                controller.filterByCategory(
                                  category.categoryId,
                                );
                              },
                              child: Container(
                                width: 80.w,
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors:
                                              AppColors.headerGradientColors,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: CommonNetworkImage(
                                        imageUrl: category.categoryImage ?? "",
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      category.categoryName ?? "",
                                      style: AppTextStyles.caption(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              // Featured Products
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    bottom: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products',
                        style: AppTextStyles.headlineMedium(),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     'See All',
                      //     style: AppTextStyles.caption().copyWith(
                      //       color: AppColors.primaryColor,
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

              // Product Grid
              // Product Grid
              Obx(() {
                if (controller.isProductLoading.value) {
                  return _ProductGridShimmer(isDark: isDark);
                }
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.68,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        // Last item pe loading indicator
                        if (index == controller.productList.length) {
                          return Obx(() {
                            if (controller.isProductLoadingMore.value) {
                              return Center(
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          });
                        }

                        return _ProductCard(
                          isDark: isDark,
                          index: index,
                          productData: controller.productList[index],
                        );
                      },
                      childCount:
                          controller.productList.length +
                          (controller.isProductLoadingMore.value ? 1 : 0),
                    ),
                  ),
                );
              }),

              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryShimmer extends StatelessWidget {
  final bool isDark;
  const _CategoryShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: 80.w,
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            child: Shimmer.fromColors(
              baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 50.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductGridShimmer extends StatelessWidget {
  final bool isDark;
  const _ProductGridShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.69,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          );
        }, childCount: 6),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final bool isDark;
  final int index;
  final ProductData? productData;
  const _ProductCard({
    required this.isDark,
    required this.index,
    required this.productData,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.PRODUCT_DETAILS,
          arguments: {"productId": productData?.productId},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor.withValues(alpha: 0.3),
                        AppColors.accentColor.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                  ),
                  child: CommonNetworkImage(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      topRight: Radius.circular(10.r),
                    ),
                    imageUrl: productData?.image ?? "",
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productData?.productName ?? "",
                    style: AppTextStyles.body().copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    productData?.description ?? "",
                    maxLines: 1,
                    style: AppTextStyles.caption().copyWith(fontSize: 12.sp),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\u20B9 ${productData?.sellingPrice ?? ""}',
                        style: AppTextStyles.body().copyWith(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.headerGradientColors,
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
