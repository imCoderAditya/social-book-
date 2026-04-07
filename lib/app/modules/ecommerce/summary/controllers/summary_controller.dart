import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart' show debugPrint;
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart'
    show ExternalWalletResponse, PaymentSuccessResponse, PaymentFailureResponse;
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/ecommerce/cart_model.dart';
import 'package:social_book/app/data/models/ecommerce/address_model.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/modules/transcation/controllers/transcation_controller.dart';
import 'package:social_book/app/modules/transcation/views/transcation_view.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/rezorpay/rezerpay_service.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

enum PaymentMethod { cod, online }

class SummaryController extends GetxController {
  Rxn<CartModel> cartModel = Rxn<CartModel>();
  Rxn<AddressData> deliveryAddress = Rxn<AddressData>();

  var selectedPaymentMethod = PaymentMethod.cod.obs;
  var isPlacingOrder = false.obs;
  var agreedToTerms = false.obs;

  @override
  void onInit() {
    final map = Get.arguments;
    if (map != null) {
      cartModel.value = map["cartData"];
      deliveryAddress.value = map["address"];
    }
    super.onInit();
  }

  // Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
    update();
  }

  // Toggle terms agreement
  void toggleTermsAgreement() {
    agreedToTerms.value = !agreedToTerms.value;
    update();
  }

  // Validate order
  bool validateOrder() {
    if (!agreedToTerms.value) {
      SnackBarUiView.showSuccess(
        message: 'Please agree to terms and conditions',
      );
      return false;
    }

    if (cartModel.value?.cartData?.isEmpty ?? true) {
      SnackBarUiView.showSuccess(message: 'Your cart is empty');
      return false;
    }

    if (deliveryAddress.value?.addressId == 0) {
      SnackBarUiView.showSuccess(message: 'Please select a delivery address');
      return false;
    }

    return true;
  }

  // Place order
  Future<void> placeOrder() async {
    if (!validateOrder()) return;

    isPlacingOrder.value = true;
    try {
      final userId = LocalStorageService.getUserId();

      final payload = {
        "CustomerId": userId.toString(),
        "ShippingAddress": deliveryAddress.value?.addressId,
        "PaymentMethod":
            selectedPaymentMethod.value == PaymentMethod.online
                ? "Online"
                : "Cod",
        "ShippingCharges": cartModel.value?.summary?.shippingCharge,
      };
      LoggerUtils.debug("Place Order Payload: ${json.encode(payload)}");

      final res = await BaseClient.post(
        api: EndPoint.ecommercePlaceOrder,
        data: payload,
      );

      if (res != null && res.statusCode == 200) {
        LoggerUtils.debug(
          "Order placed successfully: ${json.encode(res.data)}",
        );

        // Handle different payment methods
        if (selectedPaymentMethod.value == PaymentMethod.cod) {
          _handleCODSuccess(res.data["data"]["OrderID"]);
        } else {
          // _handleOnlinePayment(res.data["data"]["OrderID"]);
          await startPayment(
            name: "Payment",
            description: "Payment RezerPay",
            orderId: res.data["data"]["OrderID"],
            amount: cartModel.value?.summary?.grandTotal,
          );
        }
      } else {
        LoggerUtils.error("Failed to place order: ${json.encode(res?.data)}");
        SnackBarUiView.showSuccess(
          message: res?.data['message'] ?? 'Failed to place order',
        );
      }
    } catch (e) {
      LoggerUtils.error("Error placing order: $e");

      SnackBarUiView.showSuccess(
        message: 'Something went wrong. Please try again.',
      );
    } finally {
      isPlacingOrder.value = false;
    }
  }

  // Handle COD success
  void _handleCODSuccess(int orderId) async {
    await updatePayment(orderId: orderId, paymentStatus: "Pending");
  }

  // Handle online payment
  Future<void> _handleOnlinePayment({
    int? orderId,
    String? paymentStatus,
  }) async {
    await updatePayment(orderId: orderId, paymentStatus: paymentStatus);
  }

  Future<void> updatePayment({String? paymentStatus, int? orderId}) async {
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.post(
        api: EndPoint.ecommerceUpdatePayment,
        data: {
          "CustomerId": "$userId",
          "OrderId": orderId,
          "PaymentStatus": paymentStatus,
        },
      );
      final model = PaymentUiModel(
        initialStatus:
            paymentStatus == "Failed"
                ? PaymentStatus.failed
                : PaymentStatus.success,
        initialAmount: 999,
        initialReferenceNo: orderId.toString(),
        initialStatusText: paymentStatus == "Failed" ? "Failed" : "SUCCESS",
      );
      if (res != null && res.statusCode == 200) {
        // SnackBarUiView.showInfo(message: res.data["message"]);
        Get.offNamed(Routes.TRANSCATION, arguments: model);
      } else {
        SnackBarUiView.showInfo(message: res.data["message"]);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  // Calculate individual item total
  double getItemTotal(CartData item) {
    return (item.unitPrice ?? 0) * (item.qty ?? 0);
  }

  // Get payment method display text
  String getPaymentMethodText() {
    return selectedPaymentMethod.value == PaymentMethod.cod
        ? 'Cash on Delivery'
        : 'Online Payment';
  }

  // Get payment method icon
  String getPaymentMethodIcon() {
    return selectedPaymentMethod.value == PaymentMethod.cod ? '💵' : '💳';
  }

  // Get estimated delivery date
  String getEstimatedDelivery() {
    final deliveryDate = DateTime.now().add(const Duration(days: 7));
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${deliveryDate.day} ${months[deliveryDate.month - 1]}, ${deliveryDate.year}';
  }

  final profileController =
      Get.isRegistered()
          ? Get.find<ProfileController>()
          : Get.put(ProfileController());
  RazorPayService? razorpayService;

  Future<void> startPayment({
    String? name,
    String? description,
    double? amount,
    int? orderId,
  }) async {
    // Create the service instance
    razorpayService = RazorPayService(
      onPaymentSuccess: (PaymentSuccessResponse response) async {
        log("✅ Payment Success: $response");
        await _handleOnlinePayment(orderId: orderId, paymentStatus: "Paid");
        // handle success (maybe call your backend to verify)
      },
      onPaymentError: (PaymentFailureResponse response) async {
        log("❌ Payment Failed: ${response.code} - ${response.message}");
        await _handleOnlinePayment(orderId: orderId, paymentStatus: "Failed");
      },
      onExternalWallet: (ExternalWalletResponse response) async {
        await _handleOnlinePayment(orderId: orderId, paymentStatus: "Failed");
        log("💳 External Wallet Selected: ${response.walletName}");
      },
    );
    try {
      razorpayService?.openCheckout(
        amountInRupees: amount ?? 0.0,
        name: name ?? "",
        description: "Payment",
        contact: profileController.profileModel.value?.data?.user?.email,
        email: profileController.profileModel.value?.data?.user?.email,
      );
    } catch (e) {
      debugPrint("❌ Error in startPayment: $e");
    }
  }
}
