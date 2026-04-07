import 'package:get/get.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class SplashController extends GetxController {
  final logoScale = 0.0.obs;
  final logoOpacity = 0.0.obs;
  final textOpacity = 0.0.obs;
  final textSlideOffset = 1.0.obs;
  final loaderOpacity = 0.0.obs;
  final footerOpacity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimations();
    _navigateToHome();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    logoOpacity.value = 1.0;
    logoScale.value = 1.0;

    await Future.delayed(const Duration(milliseconds: 500));
    textOpacity.value = 1.0;
    textSlideOffset.value = 0.0;

    await Future.delayed(const Duration(milliseconds: 700));
    loaderOpacity.value = 1.0;

    await Future.delayed(const Duration(milliseconds: 900));
    footerOpacity.value = 1.0;
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    LocalStorageService.isLoggedIn()
        ? Get.offAllNamed(Routes.NAV)
        : Get.offAllNamed(Routes.LOGIN);
  }
}
