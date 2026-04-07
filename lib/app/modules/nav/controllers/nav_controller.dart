import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_book/app/modules/home/views/home_view.dart';
import 'package:social_book/app/modules/onlineUser/views/online_user_view.dart';
import 'package:social_book/app/modules/profile/views/profile_view.dart';
import 'package:social_book/app/modules/reels/controllers/reels_controller.dart';

import 'package:social_book/app/modules/reels/views/reels_view.dart';
import 'package:social_book/app/modules/ecommerce/store/views/store_view.dart';

class NavController extends GetxController {
  // Observable for current page index
  var currentIndex = 0.obs;

  // List of pages
  List<Widget> pages = [];

  // Change page method
  void changePage(int index) {
    currentIndex.value = index;

    if (currentIndex.value == 1) {
      Get.find<ReelsController>().playVideo();
    } else {
      Get.find<ReelsController>().playVideo();
    }

    pages = [
      const HomeView(),
      ReelsView(currentIndex: currentIndex.value),
      const OnlineUserView(),
      const StoreView(),
      const ProfileView(),
      // Scaffold(),
    ];
  }

  @override
  void onInit() {
    pages = [
      const HomeView(),
      ReelsView(currentIndex: currentIndex.value),
      const OnlineUserView(),
      const StoreView(),
      const ProfileView(),
      // Scaffold(),
    ];
    super.onInit();
  }
}
