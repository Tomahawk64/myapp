
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../config/app_config.dart';
import '../services/razorpay_service.dart';

/// Returned to the caller when a payment succeeds.
class PaymentResult {
  final String paymentId;
  final String? orderId;
  final String? signature;

  const PaymentResult({
    required this.paymentId,
    this.orderId,
    this.signature,
  });
}

/// Displays a payment summary and opens Razorpay checkout on mobile.
/// On web, shows a message directing the user to the mobile app.
///
/// Usage:
/// ```dart
/// final result = await Navigator.push<PaymentResult>(
///   context,
///   MaterialPageRoute(builder: (_) => PaymentScreen(amount: 999, description: 'Satyanarayan Puja')),
/// );
/// if (result != null) { /* payment succeeded */ }
/// ```
class PaymentScreen extends StatefulWidget {
  final double amount; // in INR (full rupees)
  final String description;
  final String? userName;
  final String? userEmail;
  final String? userContact;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.description,
    this.userName,
    this.userEmail,
    this.userContact,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isProcessing = false;
  String? _error;

  void _startPayment() {
    if (kIsWeb) return;

    final razorpayService =
        Provider.of<RazorpayService>(context, listen: false);

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    final options = <String, dynamic>{
      'key': AppConfig.razorpayKeyId,
      'amount': (widget.amount * 100).toInt(), // Razorpay expects paise
      'name': AppConfig.appName,
      'description': widget.description,
      'prefill': {
        'name': widget.userName ?? '',
        'email': widget.userEmail ?? '',
        'contact': widget.userContact ?? '',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    razorpayService.openPayment(
      options: options,
      onSuccess: (PaymentSuccessResponse response) {
        if (!mounted) return;
        Navigator.pop(
          context,
          PaymentResult(
            paymentId: response.paymentId ?? '',
            orderId: response.orderId,
            signature: response.signature,
          ),
        );
      },
      onError: (PaymentFailureResponse response) {
        if (!mounted) return;
        setState(() {
          _isProcessing = false;
          _error = response.message ?? 'Payment failed. Please try again.';
        });
      },
      onExternalWallet: (ExternalWalletResponse response) {
        if (!mounted) return;
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Redirecting to ${response.walletName ?? 'external wallet'}...'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order summary card ────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Divider(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(widget.description)),
                        const SizedBox(width: 16),
                        Text(
                          '₹${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹${widget.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // ── Secure payment badge ──────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.lock, size: 16, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  'Secured by Razorpay',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.green),
                ),
              ],
            ),
            // ── Web message ───────────────────────────────────────────────
            if (kIsWeb) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.orange.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Online payments via Razorpay are available on our '
                          'mobile app. Download the app to complete payment.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // ── Error message ─────────────────────────────────────────────
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            // ── Pay button ────────────────────────────────────────────────
            if (!kIsWeb)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _startPayment,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.payment),
                  label: Text(
                    _isProcessing
                        ? 'Processing...'
                        : 'Pay ₹${widget.amount.toStringAsFixed(2)}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
