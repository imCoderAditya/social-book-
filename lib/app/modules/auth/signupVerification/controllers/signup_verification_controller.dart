// OTP Verify Controller
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/modules/auth/login/controllers/login_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';

class SignupVerificationController extends GetxController {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  var maskedContact = '+91 ******1234'.obs;
  var phoneNumber = ''.obs;
  var userId = 0.obs;
  final otpComplete = false.obs;
  final isVerifying = false.obs;
  final canResend = false.obs;
  final resendTimer = 30.obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments["phone"];
    userId.value = Get.arguments["userId"];
    maskedContact.value = "+91 $phoneNumber";
    startResendTimer();
    // Focus on first field
    Future.delayed(const Duration(milliseconds: 300), () {
      focusNodes[0].requestFocus();
    });
  }

  void checkOTPComplete() {
    otpComplete.value = otpControllers.every((c) => c.text.isNotEmpty);
  }

  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 30;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      } else {
        canResend.value = true;
        return false;
      }
    });
  }

  final loginController = Get.find<LoginController>();
  void resendOTP() async {
    isVerifying.value = true;
    await loginController.sendOTP();
    isVerifying.value = false;
  }

  void verifyOTP() async {
    isVerifying.value = true;
    try {
      String otp = otpControllers.map((c) => c.text).join();

      final res = await BaseClient.post(
        api: EndPoint.signupOTPVerification,
        data: {
          "UserId": userId.value,
          "OtpCode": otp,
          "RegistrationType": "phone",
        },
      );

      if (res != null && res.statusCode == 200) {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("Verify OTP: ${json.encode(res.data)}");
        Get.offNamed(Routes.LOGIN);
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("Failed: ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.debug("Error :${e.toString()}");
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
