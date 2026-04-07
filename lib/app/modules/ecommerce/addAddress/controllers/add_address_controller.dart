import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/address_model.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';
class AddAddressController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final fullNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final houseNoController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final landmarkController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final countryController = TextEditingController(text: 'India');

  // State variables
  var isLoading = false.obs;
  var isEditMode = false.obs;
  var editAddressId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if we're in edit mode
    if (Get.arguments != null && Get.arguments is AddressData) {
      isEditMode.value = true;
      _populateFields(Get.arguments as AddressData);
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    houseNoController.dispose();
    addressLine1Controller.dispose();
    landmarkController.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    countryController.dispose();
    super.onClose();
  }

  // Populate fields for edit mode
  void _populateFields(AddressData address) {
    editAddressId.value = address.addressId ?? 0;
    fullNameController.text = address.fullName ?? '';
    mobileController.text = address.mobileNo ?? '';
    emailController.text = address.email ?? '';
    houseNoController.text = address.houseandFlatNo ?? '';
    addressLine1Controller.text = address.addressLine1 ?? '';
    landmarkController.text = address.landmark ?? '';
    cityController.text = address.city ?? '';
    stateController.text = address.state ?? '';
    pincodeController.text = address.pincode ?? '';
    countryController.text = address.country ?? 'India';
  }

  // Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      SnackBarUiView.showError(
        message: "Please fill all required fields correctly",
      );

      return false;
    }
    return true;
  }

  // Add new address
  Future<void> addAddress() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final userId = LocalStorageService.getUserId();

      final payload = {
        "customer_id": userId,
        "full_name": fullNameController.text.trim(),
        "mobile_no": mobileController.text.trim(),
        "email": emailController.text.trim(),
        "address_line1": addressLine1Controller.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
        "Pincode": pincodeController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "HouseandFlat_No": houseNoController.text.trim(),
      };

      LoggerUtils.debug("Add Address Payload: ${json.encode(payload)}");

      final res = await BaseClient.post(
        api: EndPoint.ecommerceAdAddress,
        data: payload,
      );

      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug(
          "Address added successfully: ${json.encode(res.data)}",
        );

        SnackBarUiView.showSuccess(message: 'Address added successfully');

        // Navigate back and refresh address list
        Get.back(result: true);
     
        
      } else {
        LoggerUtils.error("Failed to add address: ${json.encode(res?.data)}");

        SnackBarUiView.showError(message: res?.data['message']);
      }
    } catch (e) {
      LoggerUtils.error("Error adding address: $e");

      SnackBarUiView.showError(
        message: 'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update existing address
  Future<void> updateAddress() async {
    if (!validateForm()) return;

    isLoading.value = true;
    try {
      final userId = LocalStorageService.getUserId();

      final payload = {
        "address_id": editAddressId.value,
        "customer_id": userId,
        "full_name": fullNameController.text.trim(),
        "mobile_no": mobileController.text.trim(),
        "email": emailController.text.trim(),
        "address_line1": addressLine1Controller.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "country": countryController.text.trim(),
        "Pincode": pincodeController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "HouseandFlat_No": houseNoController.text.trim(),
      };

      LoggerUtils.debug("Update Address Payload: ${json.encode(payload)}");

      final res = await BaseClient.post(
        api: EndPoint.ecommerceUpdateAddress,
        data: payload,
      );

      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug(
          "Address updated : ${json.encode(res.data)}",
        );
        SnackBarUiView.showSuccess(message: 'Address updated successfully');
        // Navigate back and refresh address list
        Get.back(result: true);
      } else {
        LoggerUtils.error(
          "Failed to update : ${json.encode(res?.data)}",
        );

        SnackBarUiView.showError(
          message: res?.data['message'] ?? 'Failed to update address',
        );
      }
    } catch (e) {
      LoggerUtils.error("Error updating address: $e");
      SnackBarUiView.showError(
        message: 'Something went wrong. Please try again.',
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Save address (add or update based on mode)
  Future<void> saveAddress() async {
    if (isEditMode.value) {
      await updateAddress();
    } else {
      await addAddress();
    }
  }

  // Clear form
  void clearForm() {
    fullNameController.clear();
    mobileController.clear();
    emailController.clear();
    houseNoController.clear();
    addressLine1Controller.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    countryController.text = 'India';
  }

  // Validators
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (value.trim().length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Mobile number must contain only digits';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (value.trim().length != 6) {
      return 'Pincode must be 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Pincode must contain only digits';
    }
    return null;
  }
}
