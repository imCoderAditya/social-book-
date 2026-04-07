import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/config/theme/app_text_styles.dart';
import 'package:social_book/app/modules/transcation/controllers/transcation_controller.dart';

enum PaymentStatus { initial, processing, success, failed }

class TansactionView extends GetView<TranscationController> {
  const TansactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() {
        final status = controller.paymentModel.value?.paymentStatus.value;

        switch (status) {
          case PaymentStatus.initial:
          case PaymentStatus.processing:
            return _processing();
          case PaymentStatus.success:
            return _success();
          case PaymentStatus.failed:
            return _failed();
          case null:
            return _failed();
        }
      }),
    );
  }

  // ================= PROCESSING =================
  Widget _processing() {
    return Container(
      color: controller.initialScreenColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _badge(
              icon: Icons.sync,
              color: controller.initialScreenColor,
              loading: true,
            ),
            const SizedBox(height: 20),
            Text(
              "payment processing",
              style: AppTextStyles.headlineMedium().copyWith(
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SUCCESS =================
  Widget _success() {
    return Column(
      children: [
        _top(AppColors.green, Icons.check),
        Expanded(child: _bottom(isSuccess: true)),
      ],
    );
  }

  // ================= FAILED =================
  Widget _failed() {
    return Column(
      children: [
        _top(AppColors.red, Icons.priority_high),
        Expanded(child: _bottom(isSuccess: false)),
      ],
    );
  }

  Widget _top(Color color, IconData icon) {
    return Container(
      height: 220,
      width: double.infinity,
      color: color,
      child: Center(child: _badge(icon: icon, color: color)),
    );
  }

  Widget _bottom({required bool isSuccess}) {
   final payment =  controller.paymentModel.value;
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '₹${payment?.amount.value}',
            style: AppTextStyles.headlineLarge(),
          ),
          const SizedBox(height: 8),
          Text(payment?.dateTime.value??"", style: AppTextStyles.body()),
          const SizedBox(height: 8),
        RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text: "Order Id:  ",
        style: AppTextStyles.caption().copyWith(
          color: AppColors.black.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500 
        ),
      ),
      TextSpan(
        text: "#${payment?.referenceNo.value ?? ""}",
        style: AppTextStyles.caption().copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    ],
  ),
)
,
          const Spacer(),
          MaterialButton(
      
            minWidth: double.infinity,
            height: 45,
            color: AppColors.primaryColor,
            onPressed: isSuccess ? controller.finish : controller.retryPayment,
            child: Text(
              isSuccess ? "Finish" : "Try again",
              style: AppTextStyles.button,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required IconData icon,
    required Color color,
    bool loading = false,
  }) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Center(
        child:
            loading
                ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(color),
                )
                : Icon(icon, size: 40, color: color),
      ),
    );
  }
}
