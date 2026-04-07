import 'dart:developer';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Callback type definitions
typedef PaymentSuccessCallback = void Function(PaymentSuccessResponse response);
typedef PaymentErrorCallback = void Function(PaymentFailureResponse response);
typedef ExternalWalletCallback = void Function(ExternalWalletResponse response);

class RazorPayService {
  late Razorpay _razorpay;

  /// Callbacks
  final PaymentSuccessCallback onPaymentSuccess;
  final PaymentErrorCallback onPaymentError;
  final ExternalWalletCallback onExternalWallet;

  RazorPayService({
    required this.onPaymentSuccess,
    required this.onPaymentError,
    required this.onExternalWallet,
  }) {
    _razorpay = Razorpay();

    // Register event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Open Razorpay Checkout
  void openCheckout({
    required double amountInRupees, // accept in ₹ for clarity
    required String name,
    String description = "",
    String? contact,
    String? email,
  }) {
    final int amountInPaise =
        (amountInRupees * 100).toInt(); // ✅ safer conversion

    var options = {
      'key': "rzp_live_RAhdFjSs3ekRw0",
      'amount': amountInPaise,
      'name': name,
      'description': description,
      'prefill': {'contact': contact ?? "", 'email': email ?? ""},
      'theme': {
        'color': "#9932a8", // optional: custom brand color
      },
      'currency': "INR", // ✅ ensure currency is INR
    };

    try {
      _razorpay.open(options);
    } catch (e, s) {
      log("❌ Error opening Razorpay: $e\n$s");
    }
  }

  /// Success handler
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log("Payment Success: ${response.paymentId}");
    onPaymentSuccess(response);
  }

  /// Error handler
  void _handlePaymentError(PaymentFailureResponse response) {
    log("Payment Error: ${response.message}");
    onPaymentError(response);
  }

  /// External Wallet handler
  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: ${response.walletName}");
    onExternalWallet(response);
  }

  /// Dispose method (VERY IMPORTANT to prevent memory leaks)
  void dispose() {
    _razorpay.clear();
  }
}