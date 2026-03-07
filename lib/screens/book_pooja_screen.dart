import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/booking.dart';
import '../models/pooja_package.dart';
import '../services/booking_service.dart';
import '../services/app_notification_service.dart';
import 'payment_screen.dart';

class BookPoojaScreen extends StatefulWidget {
  final PoojaPackage poojaPackage;

  const BookPoojaScreen({super.key, required this.poojaPackage});

  @override
  State<BookPoojaScreen> createState() => _BookPoojaScreenState();
}

class _BookPoojaScreenState extends State<BookPoojaScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  BookingType _bookingType = BookingType.online;
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _proceedToPayment(AppUser user) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date.')),
      );
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!kIsWeb) {
      // Mobile: open Razorpay checkout
      final paymentResult = await navigator.push<PaymentResult>(
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            amount: widget.poojaPackage.price,
            description: widget.poojaPackage.name,
            userName: user.displayName,
            userEmail: user.email,
          ),
        ),
      );
      if (paymentResult == null || !mounted) return;
      await _createBooking(
        user: user,
        paymentStatus: PaymentStatus.completed,
        transactionId: paymentResult.paymentId,
        navigator: navigator,
        messenger: messenger,
      );
    } else {
      // Web: confirm dialog (no payment gateway on web)
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Confirm Booking'),
          content: Text(
            'Book "${widget.poojaPackage.name}" for '
            '₹${widget.poojaPackage.price.toStringAsFixed(2)}?\n\n'
            'Payment can be made via the mobile app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
      if (confirm != true || !mounted) return;
      await _createBooking(
        user: user,
        paymentStatus: PaymentStatus.pending,
        navigator: navigator,
        messenger: messenger,
      );
    }
  }

  Future<void> _createBooking({
    required AppUser user,
    required PaymentStatus paymentStatus,
    String? transactionId,
    required NavigatorState navigator,
    required ScaffoldMessengerState messenger,
  }) async {
    setState(() => _isLoading = true);
    try {
      final booking = Booking(
        id: '',
        userId: user.id,
        poojaId: widget.poojaPackage.id,
        bookingType: _bookingType,
        date: _selectedDate!,
        status: BookingStatus.pending,
        price: widget.poojaPackage.price,
        paymentStatus: paymentStatus,
        transactionId: transactionId,
        createdAt: DateTime.now(),
        address: _bookingType == BookingType.offline
            ? _addressController.text.trim()
            : null,
      );
      await BookingService().createBooking(booking);

      // Write in-app notification for this user
      await AppNotificationService().sendNotification(
        userId: user.id,
        message: 'Your booking for "${widget.poojaPackage.name}" has been '
            'submitted and is awaiting pandit assignment.',
      );

      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Booking confirmed! You will be notified once a pandit is assigned.',
            ),
          ),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to create booking: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.poojaPackage.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Package summary ──────────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.poojaPackage.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(widget.poojaPackage.description),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.currency_rupee, size: 18),
                          Text(
                            widget.poojaPackage.price.toStringAsFixed(2),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.timer, size: 18),
                          const SizedBox(width: 4),
                          Text('${widget.poojaPackage.durationInMinutes} min'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Booking type ─────────────────────────────────────────────
              Text('Booking Type',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              SegmentedButton<BookingType>(
                segments: const [
                  ButtonSegment(
                    value: BookingType.online,
                    label: Text('Online'),
                    icon: Icon(Icons.video_call),
                  ),
                  ButtonSegment(
                    value: BookingType.offline,
                    label: Text('In-Person'),
                    icon: Icon(Icons.home),
                  ),
                ],
                selected: {_bookingType},
                onSelectionChanged: (s) =>
                    setState(() => _bookingType = s.first),
              ),
              const SizedBox(height: 24),

              // ── Date picker ──────────────────────────────────────────────
              Text('Select Date',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Choose a date'
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.grey : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Address (offline only) ───────────────────────────────────
              if (_bookingType == BookingType.offline) ...[
                const SizedBox(height: 24),
                Text('Address',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Address is required for in-person booking'
                      : null,
                ),
              ],
              const SizedBox(height: 32),

              // ── CTA button ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading || user == null
                      ? null
                      : () => _proceedToPayment(user),
                  icon: _isLoading
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
                    _isLoading
                        ? 'Please wait...'
                        : (kIsWeb ? 'Confirm Booking' : 'Proceed to Payment'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
