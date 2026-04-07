// OTP Verify Controller
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/auth/login/login_model.dart';
import 'package:social_book/app/modules/auth/login/controllers/login_controller.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class OtpVerifyController extends GetxController {
  Rxn<LoginModel> loginModel = Rxn<LoginModel>();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  var maskedContact = '+91 ******1234'.obs;
  var phoneNumber = ''.obs;
  final otpComplete = false.obs;
  final isVerifying = false.obs;
  final canResend = false.obs;
  final resendTimer = 30.obs;

  @override
  void onInit() {
    super.onInit();
    phoneNumber.value = Get.arguments["phone"];
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
    clearOtp();
    await loginController.sendOTP();
    isVerifying.value = false;
    update();
  }

  void verifyOTP() async {
    isVerifying.value = true;

    isVerifying.value = true;
    try {
      String otp = otpControllers.map((c) => c.text).join();

      final res = await BaseClient.post(
        api: EndPoint.login,
        data: {
          "LoginType": "otp",
          "Phone": phoneNumber.value,
          "OTP": otp,
          "DeviceToken": "vvvvvvvvvvvvvvvvvvvv",
        },
      );

      loginModel.value = loginModelFromJson(json.encode(res.data));
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Verify OTP: ${json.encode(loginModel.value)}");
        if (loginModel.value?.success == true) {
          final userData = loginModel.value?.data?.user;
          // Save Local  Data
          final profiles = userData?.profiles ?? [];
          LocalStorageService.saveLogin(
            userId: userData?.userId ?? 0,
            token: loginModel.value?.data?.accessToken ?? "",
            refreshToken: loginModel.value?.data?.refreshToken ?? "",
            userSocialProfileId:
                profiles.isNotEmpty ? profiles[0].profileId : null,

            userProfessionalProfileId:
                profiles.length > 1 ? profiles[1].profileId : null,

            userHiddenProfileId:
                profiles.length > 2 ? profiles[2].profileId : null,

            userMatrimonialProfileId:
                profiles.length > 3 ? profiles[3].profileId : null,
          );

          // if (loginModel.value?.data?.user?.profiles?.isEmpty ?? true) {
          //   Get.offAllNamed(Routes.PROFILE_SELECTION);
          // } else {
          //   Get.offAllNamed(Routes.SWITCH_PROFILE);

          // }
          Get.offAllNamed(Routes.SWITCH_PROFILE);
        }
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

void clearOtp() {
  for (final controller in otpControllers) {
    controller.clear();
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
