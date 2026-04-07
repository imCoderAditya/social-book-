import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/address_model.dart';
import 'package:social_book/app/data/models/ecommerce/cart_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class AddressController extends GetxController {
  var isLoading = false.obs;
  var isLoadingDelete = false.obs;
  Rxn<AddressModel> addressModel = Rxn<AddressModel>();
  Rxn<AddressData> selectAddressData = Rxn<AddressData>();

  Rxn<CartModel> cartModel = Rxn<CartModel>();

  @override
  void onInit() {
    fetchAddress();
    cartModel.value = Get.arguments;
    log("Cart Model: ${json.encode(cartModel.value)}");
    super.onInit();
  }

  // Fetch all addresses
  Future<void> fetchAddress() async {
    isLoading.value = true;
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(
        api: "${EndPoint.ecommerceAddress}?customerId=$userId",
      );
      if (res != null && res.statusCode == 200) {
        addressModel.value = addressModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Address Data: ${json.encode(addressModel.value)}");

        // Auto-select first address if none selected
        if (addressModel.value?.addressData?.isNotEmpty ?? false) {
          if (selectAddressData.value == null) {
            selectAddressData.value = addressModel.value!.addressData!.first;
          }
        }
      } else {
        LoggerUtils.warning(
          "Failed to fetch addresses: ${json.encode(res?.data)}",
        );
        SnackBarUiView.showError(message: "Something went wrong");
      }
    } catch (e) {
      LoggerUtils.error("Error fetching addresses: $e");
      SnackBarUiView.showError(message: "Something went wrong");
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Select an address
  void selectAddress({int? addressId, AddressData? addressData}) {
    selectAddressData.value = addressData;
    update();
    LoggerUtils.debug("Selected address ID: $addressId");
  }

  // Delete an address
  Future<void> deleteAddress(int addressId) async {
    isLoadingDelete.value = true;
    try {
      final userId = LocalStorageService.getUserId();

      // Make API call to delete
      final res = await BaseClient.post(
        api: EndPoint.ecommerceAddressDelete,
        data: {"addressId": addressId, "customerId": userId},
      );

      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Address deleted successfully");

        // Refresh the list
        await fetchAddress();
        addressModel.value = null;
        selectAddressData.value = null;
      } else {
        LoggerUtils.warning(
          "Failed to delete address: ${json.encode(res?.data)}",
        );
        SnackBarUiView.showError(message: 'Could not delete address');
      }
    } catch (e) {
      LoggerUtils.error("Error deleting address: $e");
      SnackBarUiView.showError(message: 'Something went wrong');
    } finally {
      isLoadingDelete.value = false;
      update();
    }
  }
}
