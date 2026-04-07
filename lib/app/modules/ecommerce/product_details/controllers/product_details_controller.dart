import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/product_details_model.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class ProductDetailsController extends GetxController {
  RxInt quantity = 1.obs;
  Rxn<ProductDetailsModel> productDetailsModel = Rxn<ProductDetailsModel>();
  RxInt productId = RxInt(0);
  var isLoading = false.obs;
  var isLoadingAddTocart = false.obs;

  // Selected variant and color
  Rxn<Variant> selectedVariant = Rxn<Variant>();
  Rxn<Color> selectedColor = Rxn<Color>();

  @override
  void onInit() {
    productId.value = Get.arguments["productId"];
    fetchProductDetails();
    super.onInit();
  }

  Future<void> fetchProductDetails() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.get(
        api: "${EndPoint.ecommerceProductDetails}/${productId.value}",
      );

      if (res != null && res.statusCode == 200) {
        log("Product Details ${json.encode(res.data)}");
        productDetailsModel.value = productDetailsModelFromJson(
          json.encode(res.data),
        );

        // Auto-select first variant and color if available
        _initializeSelections();
      } else {
        log("Product Details Failed ${json.encode(res?.data)}");
      }
    } catch (e) {
      LoggerUtils.debug("Error: $e");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  void _initializeSelections() {
    final productDetails = productDetailsModel.value?.productDetails;
    if (productDetails?.variants != null &&
        productDetails!.variants!.isNotEmpty) {
      // Select first variant
      selectedVariant.value = productDetails.variants!.firstOrNull;

      // Select first color of first variant
      if (selectedVariant.value?.colors != null &&
          selectedVariant.value!.colors!.isNotEmpty) {
        selectedColor.value = selectedVariant.value!.colors!.firstOrNull;
      }
    }
  }

  void selectVariant(Variant variant) {
    selectedVariant.value = variant;

    // Auto-select first color of the selected variant
    if (variant.colors != null && variant.colors!.isNotEmpty) {
      selectedColor.value = variant.colors!.firstOrNull;
    } else {
      selectedColor.value = null;
    }
    update();
  }

  void selectColor(Color color) {
    selectedColor.value = color;
    update();
  }

  // Quantity ---
  int get maxStock =>
      selectedVariant.value?.stock ??
      productDetailsModel.value?.productDetails?.inStock ??
      0;

  void increaseQty() {
    if (quantity.value < maxStock) {
      quantity.value++;
    }
  }

  void decreaseQty() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void resetQty() {
    quantity.value = 1;
  }

  //--- Add-TO-Cart

  Future<void> addToCart() async {
    isLoadingAddTocart.value = true;
    try {
      final variant = selectedVariant.value;
      final stock = selectedVariant.value?.stock ?? productDetailsModel.value?.productDetails?.inStock;
      final variantsList = productDetailsModel.value?.productDetails?.variants??[];
      if (variant == null && variantsList.isNotEmpty) {
        SnackBarUiView.showError(message: "Please select a size");
        return;
      }

      if ((stock ?? 0) <= 0) {
        SnackBarUiView.showError(message: "Product is out of stock");
        return;
      }
      final userId = LocalStorageService.getUserId();
      final payload = {
        "productId": productId.value,
        "variantId": variant?.sizeId??"", // 🔥 IMPORTANT
        "qty": quantity.value,
        "userId": userId, // logged in user
      };

      log("ADD TO CART PAYLOAD => $payload");

      final res = await BaseClient.post(
        api: EndPoint.ecommerceAddToCart,
        data: payload,
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Add TO cart Response : ${json.encode(res.data)}");
        Get.offNamed(Routes.CART);
      } else {
        LoggerUtils.debug("Add TO cart Failed : ${json.encode(res.data)}");
      }
    } catch (e) {
      SnackBarUiView.showError(message: "Something went wrong");
    } finally {
      isLoadingAddTocart.value = false;
      update();
    }
  }

}
