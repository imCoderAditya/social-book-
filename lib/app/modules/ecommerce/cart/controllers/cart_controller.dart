import 'dart:convert';

import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/cart_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class CartController extends GetxController {
  var isLoading = false.obs;
  Rxn<CartModel> cartModel = Rxn<CartModel>();

  Future<void> fetchCart() async {
    isLoading.value = true;
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(
        api: "${EndPoint.ecommerceShowCart}?customerId=$userId",
      );

      if (res != null && res.statusCode == 200) {
        cartModel.value = cartModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Cart Data : ${json.encode(cartModel.value)}");
      } else {
        LoggerUtils.error("Cart Data : ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> updateQuantity({int? cartId, int? qty}) async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.ecommerceQtyUpdate,
        data: {"CartId": cartId, "Qty": qty},
      );

      if (res != null && res.statusCode == 200) {
        SnackBarUiView.showInfo(message: res.data["message"]);
        await fetchCart();
      } else {
        LoggerUtils.error("Cart Data : ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> deleteItemAPI({int? cartId}) async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.ecommerceDeleteItem,
        data: {"CartId": cartId},
      );

      if (res != null && res.statusCode == 200) {
        SnackBarUiView.showInfo(message: res.data["message"]);
        await fetchCart();
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.error("Cart Data : ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      Get.back();
      isLoading.value = false;
      update();
    }
  }

  Future<void> increaseQty(int index) async {
    final items = cartModel.value?.cartData;
    if (items == null || index >= items.length) return;

    final item = items[index];
    final currentQty = item.qty ?? 1;

    // 🚫 Max limit check
    if (currentQty >= 10) {
      SnackBarUiView.showError(message: "Maximum 10 items allowed");
      return;
    }

    await updateQuantity(cartId: item.id, qty: currentQty + 1);
  }

  Future<void> decreaseQty(int index) async {
    final items = cartModel.value?.cartData;
    if (items == null || index >= items.length) return;

    final item = items[index];
    final currentQty = item.qty ?? 1;

    // 🚫 Min limit check
    if (currentQty <= 1) {
      return; // silently ignore
    }
    await updateQuantity(cartId: item.id, qty: currentQty - 1);
  }



  @override
  void onInit() {
    fetchCart();
    super.onInit();
  }
}
