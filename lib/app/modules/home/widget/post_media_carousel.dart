// post_media_carousel.dart
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/modules/home/widget/video_post_item.dart';

class PostMediaCarousel extends StatelessWidget {
  final List<String> mediaUrls;
  final String postType;
  final bool isDark;
  final double height;


  PostMediaCarousel({
    super.key,
    required this.mediaUrls,
    required this.postType,
    required this.isDark,
    required this.height,
 
  });

  final RxInt _currentIndex = 0.obs; // Changed to 0-based indexing
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (mediaUrls.isEmpty) return const SizedBox();

    return CarouselSlider(
      carouselController: _carouselController,
      items: mediaUrls.asMap().entries.map((entry) {
        int index = entry.key;
        String url = entry.value;
        
        return Stack(
          children: [
            postType.toLowerCase() == "video"
                ? Obx(() => VideoPostItem(
                    videoUrl: url,
                  
                    isCurrentSlide: _currentIndex.value == index, // Only current video plays
                  ))
                : _imageItem(url),
            if (mediaUrls.length > 1) _counter(), // Only show counter if multiple items
          ],
        );
      }).toList(),
      options: CarouselOptions(
        height: height,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: false,
        clipBehavior: Clip.hardEdge,
        onPageChanged: (index, reason) {
          _currentIndex.value = index; // Update to 0-based index
        },
      ),
    );
  }

  Widget _imageItem(String url) {
    return SizedBox(
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _counter() {
    return Obx(() {
      return Positioned(
        top: 10,
        right: 10,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${_currentIndex.value + 1}/${mediaUrls.length}', // Display as 1-based
            style: AppTextStyles.body().copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      );
    });
  }

  Widget _fallback() {
    return Center(
      child: Icon(
        Icons.image,
        size: 80,
        color: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
      ),
    );
  }
}