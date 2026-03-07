
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../models/pandit_profile.dart';
import '../services/app_notification_service.dart';
import '../services/consultation_session_service.dart';
import '../services/pandit_service.dart';
import '../services/review_service.dart';
import 'consultation_chat_screen.dart';
import 'payment_screen.dart';

class PanditListScreen extends StatefulWidget {
  const PanditListScreen({super.key});

  @override
  State<PanditListScreen> createState() => _PanditListScreenState();
}

class _PanditListScreenState extends State<PanditListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Consultation')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                labelText: 'Search for a pandit',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: StreamProvider<List<PanditProfile>>.value(
              value: PanditService().getPandits(),
              initialData: const [],
              child: _PanditGrid(searchQuery: _searchQuery),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanditGrid extends StatelessWidget {
  final String searchQuery;

  const _PanditGrid({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    final pandits = Provider.of<List<PanditProfile>>(context)
        .where((p) =>
            p.bio.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.location.toLowerCase().contains(searchQuery.toLowerCase()) ||
            p.specialities
                .any((s) => s.toLowerCase().contains(searchQuery.toLowerCase())))
        .toList();

    if (pandits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_search, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              searchQuery.isEmpty
                  ? 'No pandits available.'
                  : 'No pandits found for "$searchQuery".',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: pandits.length,
      itemBuilder: (context, index) {
        final pandit = pandits[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PanditDetailsScreen(pandit: pandit),
            ),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.person,
                            size: 56, color: Colors.deepPurple),
                        if (pandit.isVerified)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Icon(Icons.verified,
                                size: 18, color: Colors.blue),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pandit.location.isNotEmpty
                            ? pandit.location
                            : 'Pandit',
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pandit.specialities.take(2).join(', '),
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      StreamBuilder<double>(
                        stream:
                            ReviewService().getPanditAverageRating(pandit.id),
                        builder: (context, snapshot) {
                          final rating = snapshot.data;
                          if (rating == null) {
                            return const Text('No ratings',
                                style: TextStyle(fontSize: 11));
                          }
                          return Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Pandit Details Screen — Profile + Book Consultation
// ════════════════════════════════════════════════════════════════════════════

class PanditDetailsScreen extends StatefulWidget {
  final PanditProfile pandit;

  const PanditDetailsScreen({super.key, required this.pandit});

  @override
  State<PanditDetailsScreen> createState() => _PanditDetailsScreenState();
}

class _PanditDetailsScreenState extends State<PanditDetailsScreen> {
  // Default consultation options (minutes → price in INR)
  static const _durations = [
    (minutes: 15, price: 299.0),
    (minutes: 30, price: 499.0),
    (minutes: 60, price: 899.0),
  ];

  int _selectedDurationIndex = 0;
  bool _isBooking = false;

  Future<void> _bookConsultation(AppUser user) async {
    final selected = _durations[_selectedDurationIndex];
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (!kIsWeb) {
      // Mobile: pay first
      final paymentResult = await navigator.push<PaymentResult>(
        MaterialPageRoute(
          builder: (_) => PaymentScreen(
            amount: selected.price,
            description: '${selected.minutes}-min consultation',
            userName: user.displayName,
            userEmail: user.email,
          ),
        ),
      );
      if (paymentResult == null || !mounted) return;
    } else {
      // Web: confirm dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Book Consultation'),
          content: Text(
            'Book a ${selected.minutes}-min consultation for '
            '₹${selected.price.toStringAsFixed(0)}?',
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
    }

    setState(() => _isBooking = true);
    try {
      final session = await ConsultationSessionService().createSession(
        user.id,
        widget.pandit.id,
        selected.minutes,
        selected.price,
      );

      await AppNotificationService().sendNotification(
        userId: user.id,
        message:
            'Your consultation session (${selected.minutes} min) has been booked.',
      );

      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text('Consultation booked! Waiting for pandit.')),
        );
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (_) =>
                ConsultationChatScreen(sessionId: session.id),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
            SnackBar(content: Text('Failed to book consultation: $e')));
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final pandit = widget.pandit;

    return Scaffold(
      appBar: AppBar(title: const Text('Pandit Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile header ─────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.person,
                      size: 48, color: Colors.deepPurple),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            pandit.location.isNotEmpty
                                ? pandit.location
                                : 'Pandit',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (pandit.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.verified,
                                color: Colors.blue, size: 20),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${pandit.experience} years experience',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      StreamBuilder<double>(
                        stream:
                            ReviewService().getPanditAverageRating(pandit.id),
                        builder: (context, snap) {
                          final r = snap.data;
                          if (r == null) {
                            return const Text('No ratings yet');
                          }
                          return Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(r.toStringAsFixed(1)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Bio ───────────────────────────────────────────────────────
            Text('About',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(pandit.bio.isNotEmpty ? pandit.bio : 'No bio provided.'),
            const SizedBox(height: 24),

            // ── Specialities ──────────────────────────────────────────────
            Text('Specialities',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: pandit.specialities
                  .map((s) => Chip(label: Text(s)))
                  .toList(),
            ),
            const SizedBox(height: 24),

            // ── Languages ─────────────────────────────────────────────────
            if (pandit.languages.isNotEmpty) ...[
              Text('Languages',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: pandit.languages
                    .map((l) => Chip(
                          label: Text(l),
                          backgroundColor: Colors.deepPurple.shade50,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // ── Book consultation ─────────────────────────────────────────
            const Divider(),
            const SizedBox(height: 16),
            Text('Book a Consultation',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Text('Select duration:',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_durations.length, (i) {
                final d = _durations[i];
                final selected = _selectedDurationIndex == i;
                return Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        setState(() => _selectedDurationIndex = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${d.minutes} min',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: selected ? Colors.white : null,
                            ),
                          ),
                          Text(
                            '₹${d.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  selected ? Colors.white70 : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isBooking || user == null
                    ? null
                    : () => _bookConsultation(user),
                icon: _isBooking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.video_call),
                label: Text(
                  _isBooking
                      ? 'Booking…'
                      : (kIsWeb ? 'Book Consultation' : 'Pay & Book'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
