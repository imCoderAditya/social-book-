import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/auth/login/login_model.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

enum LoginType { email, mobile, google }

class LoginController extends GetxController {
  Rxn<LoginModel> loginModel = Rxn<LoginModel>();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Rx<LoginType> loginType = LoginType.mobile.obs;
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Login With OTP

  Future<void> sendOTP() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.sendOTP,
        data: {"Phone": phoneController.text.trim()},
      );
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Send OTP: ${json.encode(res.data)}");
        if (res.data["success"] == true) {
          Get.toNamed(
            Routes.OTP_VERIFY,
            arguments: {"phone": phoneController.text.trim()},
          );
        }
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("Failed: ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.debug("Error res:${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      final res = await BaseClient.post(
        api: EndPoint.login,
        data: {
          "LoginType": "password",
          "Email": emailController.text.trim(),
          "Password": passwordController.text.trim(),
          "DeviceToken": "pppppppppppppp",
        },
      );

      loginModel.value = loginModelFromJson(json.encode(res.data));
      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug("Email With Login: ${json.encode(loginModel.value)}");
        if (loginModel.value?.success == true) {
          final userData = loginModel.value?.data?.user;
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
          Get.offAllNamed(Routes.SWITCH_PROFILE);
        }
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
        LoggerUtils.debug("Failed: ${json.encode(res.data)}");
      }
    } catch (e) {
      LoggerUtils.debug("Error :${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
