
import 'package:flutter/foundation.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Wraps the Razorpay SDK with per-payment callback support.
/// The service is registered in the Provider tree and disposed with it.
class RazorpayService {
  Razorpay? _razorpay;

  Function(PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onError;
  Function(ExternalWalletResponse)? _onExternalWallet;

  RazorpayService() {
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  /// Opens the Razorpay checkout with [options].
  /// Registers per-payment callbacks; throws [UnsupportedError] on web.
  void openPayment({
    required Map<String, dynamic> options,
    required Function(PaymentSuccessResponse) onSuccess,
    required Function(PaymentFailureResponse) onError,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    if (kIsWeb || _razorpay == null) {
      throw UnsupportedError('Razorpay is not supported on web.');
    }
    _onSuccess = onSuccess;
    _onError = onError;
    _onExternalWallet = onExternalWallet;
    _razorpay!.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
    _clearCallbacks();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _onError?.call(response);
    _clearCallbacks();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onExternalWallet?.call(response);
    _clearCallbacks();
  }

  void _clearCallbacks() {
    _onSuccess = null;
    _onError = null;
    _onExternalWallet = null;
  }

  void dispose() {
    _razorpay?.clear();
  }
}
