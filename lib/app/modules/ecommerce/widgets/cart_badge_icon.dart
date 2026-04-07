import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:social_book/app/modules/ecommerce/cart/controllers/cart_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: CartController(),
      builder: (controller) {
        return Obx(() {
          final count = controller.cartModel.value?.cartData?.length ?? 0;
          log("count:  $count");
          return Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: badges.Badge(
              showBadge: count > 0,

              position: badges.BadgePosition.topEnd(top: 2, end: 2),
              badgeContent: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.toNamed(Routes.CART);
                },
              ),
            ),
          );
        });
      },
    );
  }
}
