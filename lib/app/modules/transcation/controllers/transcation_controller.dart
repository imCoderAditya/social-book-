import 'dart:ui';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/utils/date_utils.dart';
import 'package:social_book/app/modules/transcation/views/transcation_view.dart';
import 'package:social_book/app/routes/app_pages.dart';

class TranscationController extends GetxController {
  /// 🔹 UI MODEL (nullable + reactive)
  final Rxn<PaymentUiModel> paymentModel = Rxn<PaymentUiModel>();

  /// Screen color
  Color initialScreenColor = AppColors.secondaryPrimary;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final arg = Get.arguments;

    if (arg is PaymentUiModel) {
      paymentModel.value = arg;
    } else {
      paymentModel.value = PaymentUiModel(
        initialStatus: PaymentStatus.failed,
        initialStatusText: "FAILED",
      );
    }

    final model = paymentModel.value!;

    /// 🔥 Save final status FIRST
    final PaymentStatus finalStatus = model.paymentStatus.value;

    /// Show processing
    model.paymentStatus.value = PaymentStatus.processing;
    initialScreenColor = AppColors.secondaryPrimary;

    model.refreshDateTime();

    /// Delay
    await Future.delayed(const Duration(seconds: 2));

    /// Show final screen
    model.paymentStatus.value = finalStatus;
    initialScreenColor =
        finalStatus == PaymentStatus.failed
            ? AppColors.red
            : AppColors.sucessPrimary;
  }

  /// ================= ACTIONS =================
  void retryPayment() {
    Get.offNamed(Routes.NAV);
  }

  void finish() {
    Get.offNamed(Routes.NAV);
  }

  void invoiceDownload() {}
}

class PaymentUiModel {
  final Rx<PaymentStatus> paymentStatus;
  final RxDouble amount;
  final RxString referenceNo;
  final RxString dateTime;
  final RxString status;

  PaymentUiModel({
    PaymentStatus initialStatus = PaymentStatus.initial,
    double initialAmount = 0.0,
    String initialReferenceNo = '',
    String initialStatusText = '',
  }) : paymentStatus = initialStatus.obs,
       amount = initialAmount.obs,
       referenceNo = initialReferenceNo.obs,
       status = initialStatusText.obs,
       dateTime =
           AppDateUtils.extractDate(DateTime.now().toIso8601String(), 15).obs;

  void refreshDateTime() {
    dateTime.value = AppDateUtils.extractDate(
      DateTime.now().toIso8601String(),
      15,
    );
  }
}
