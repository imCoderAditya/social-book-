import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:social_book/app/components/common_network_image.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  final bool isDark;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.isDark,
  });

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
        ),
        child: Center(
          child: Icon(
            Icons.image_not_supported,
            size: 64.sp,
            color: widget.isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      );
    }

    return Container(
      color: widget.isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Column(
        children: [
          // Main Carousel
          CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.images.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CommonNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 300.h,
              viewportFraction: 0.85,
              enlargeCenterPage: true,
              enableInfiniteScroll: widget.images.length > 1,
              autoPlay: widget.images.length > 1,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          SizedBox(height: 16.h),

          // Indicators
          if (widget.images.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: Container(
                    width: _currentIndex == entry.key ? 24.w : 8.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.r),
                      color: _currentIndex == entry.key
                          ? AppColors.primaryColor
                          : (widget.isDark
                              ? AppColors.darkTextSecondary.withOpacity(0.3)
                              : AppColors.lightTextSecondary.withOpacity(0.3)),
                    ),
                  ),
                );
              }).toList(),
            ),

          SizedBox(height: 16.h),

          // Thumbnail Gallery
          if (widget.images.length > 1)
            SizedBox(
              height: 80.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: widget.images.length,
                itemBuilder: (context, index) {
                  final isSelected = _currentIndex == index;
                  return GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(index);
                    },
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : (widget.isDark
                                  ? AppColors.darkDivider
                                  : AppColors.lightDivider),
                          width: isSelected ? 2.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.r),
                        child: CommonNetworkImage(
                          imageUrl: widget.images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}