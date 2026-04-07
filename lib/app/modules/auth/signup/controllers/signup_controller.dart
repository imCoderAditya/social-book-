// SignUp Controller
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final acceptedTerms = false.obs;
  final isLoading = false.obs;

  final passwordsMatch = false.obs;
  final isFormValid = false.obs;
  var confirmPasswordText = "".obs;
  @override
  void onInit() {
    super.onInit();

    // Listen to password changes
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    phoneController.addListener(_validateForm);

    ever(acceptedTerms, (_) => _validateForm());
  }

  void _validateForm() {
    // Check if passwords match
    passwordsMatch.value =
        passwordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;

    // Check if form is valid
    isFormValid.value =
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordsMatch.value &&
        acceptedTerms.value &&
        _isValidEmail(emailController.text) &&
        phoneController.text.length >= 10;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> signUp() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.signup,
        data: {
          "Email": emailController.text.trim(),
          "Password": passwordController.text.trim(),
          "PhoneNumber": phoneController.text.trim(),
          "RegistrationType": "phone",
        },
      );

      if (res != null && res.statusCode == 201) {
        LoggerUtils.debug("SignUp : ${json.encode(res.data)}");
        SnackBarUiView.showInfo(message: res.data["message"]);
        Get.offNamed(
          Routes.SIGNUP_VERIFICATION,
          arguments: {
            "phone": phoneController.text.trim(),
            "userId": res.data["data"]["userId"] ?? 0,
          },
        );
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("SignUp : ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
