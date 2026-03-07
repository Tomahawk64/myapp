import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/pandit_profile.dart';
import '../services/app_notification_service.dart';
import 'admin_panel_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_note_outlined),
              tooltip: 'Manage Content',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AdminPanelScreen(),
                ),
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
              Tab(icon: Icon(Icons.person), text: 'Pandits'),
              Tab(icon: Icon(Icons.book_online), text: 'Bookings'),
              Tab(icon: Icon(Icons.star), text: 'Reviews'),
              Tab(icon: Icon(Icons.campaign), text: 'Announce'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _OverviewTab(),
            _PanditsTab(),
            _BookingsTab(),
            _ReviewsTab(),
            _AnnouncementsTab(),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Overview Tab
// ════════════════════════════════════════════════════════════════════════════

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatCard(
            title: 'Total Users',
            icon: Icons.people,
            stream: db.collection('users').snapshots(),
            color: Colors.blue),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Total Bookings',
            icon: Icons.book_online,
            stream: db.collection('bookings').snapshots(),
            color: Colors.orange),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Pandits',
            icon: Icons.person_pin,
            stream: db.collection('pandit_profiles').snapshots(),
            color: Colors.purple),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Pooja Packages',
            icon: Icons.spa,
            stream: db.collection('pooja_packages').snapshots(),
            color: Colors.green),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Consultations',
            icon: Icons.video_call,
            stream: db.collection('consultation_sessions').snapshots(),
            color: Colors.teal),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Reviews',
            icon: Icons.star,
            stream: db.collection('reviews').snapshots(),
            color: Colors.amber),
        const SizedBox(height: 12),
        _StatCard(
            title: 'Orders',
            icon: Icons.shopping_bag,
            stream: db.collection('orders').snapshots(),
            color: Colors.red),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Stream<QuerySnapshot> stream;
  final Color color;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.stream,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color),
            ),
            title: Text(title),
            trailing: snapshot.connectionState == ConnectionState.waiting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    '$count',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Pandits Tab — Approve / Revoke / Delete
// ════════════════════════════════════════════════════════════════════════════

class _PanditsTab extends StatelessWidget {
  const _PanditsTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pandit_profiles')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No pandit profiles found.',
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final isVerified = data['isVerified'] as bool? ?? false;
            final profile = PanditProfile.fromFirestore(doc);

            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isVerified
                      ? Colors.green.shade100
                      : Colors.orange.shade100,
                  child: Icon(
                    isVerified ? Icons.verified_user : Icons.person,
                    color: isVerified ? Colors.green : Colors.orange,
                  ),
                ),
                title: Text(
                  profile.location.isNotEmpty
                      ? profile.location
                      : 'Pandit ${profile.id.substring(0, 6)}',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.specialities.take(3).join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      isVerified ? '✓ Verified' : '⏳ Pending approval',
                      style: TextStyle(
                        color: isVerified ? Colors.green : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isVerified)
                      IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: Colors.green),
                        tooltip: 'Approve pandit',
                        onPressed: () => _updateVerification(
                          context,
                          doc.id,
                          profile.id,
                          verified: true,
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.orange),
                        tooltip: 'Revoke verification',
                        onPressed: () => _updateVerification(
                          context,
                          doc.id,
                          profile.id,
                          verified: false,
                        ),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      tooltip: 'Delete profile',
                      onPressed: () => _confirmDelete(
                          context, doc.reference, 'pandit profile'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _updateVerification(
    BuildContext context,
    String docId,
    String userId, {
    required bool verified,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    await FirebaseFirestore.instance
        .collection('pandit_profiles')
        .doc(docId)
        .update({'isVerified': verified});

    if (context.mounted) {
      await AppNotificationService().sendNotification(
        userId: userId,
        message: verified
            ? 'Congratulations! Your pandit profile has been approved. You can now accept bookings.'
            : 'Your pandit verification has been revoked. Contact support for assistance.',
      );
      messenger.showSnackBar(
        SnackBar(
          content: Text(
              verified ? 'Pandit approved.' : 'Verification revoked.'),
        ),
      );
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Bookings Tab
// ════════════════════════════════════════════════════════════════════════════

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('No bookings yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final status = data['status'] as String? ?? 'pending';
            final paymentStatus =
                data['paymentStatus'] as String? ?? 'pending';
            final price =
                (data['price'] as num?)?.toDouble() ?? 0;

            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: _statusIcon(status),
                title: Text(
                  data['poojaId'] as String? ?? 'Unknown pooja',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: $status'),
                    Text(
                        'Payment: $paymentStatus  •  ₹${price.toStringAsFixed(0)}'),
                  ],
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  tooltip: 'Change status',
                  onSelected: (value) =>
                      _updateStatus(context, docs[index].id, value),
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                        value: 'confirmed', child: Text('Mark Confirmed')),
                    PopupMenuItem(
                        value: 'completed', child: Text('Mark Completed')),
                    PopupMenuItem(
                        value: 'cancelled', child: Text('Cancel')),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _statusIcon(String status) {
    final (icon, color) = switch (status) {
      'confirmed' => (Icons.check_circle, Colors.green),
      'completed' => (Icons.done_all, Colors.blue),
      'cancelled' => (Icons.cancel, Colors.red),
      'assigned' => (Icons.person_pin, Colors.purple),
      _ => (Icons.hourglass_bottom, Colors.orange),
    };
    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.15),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Future<void> _updateStatus(
      BuildContext context, String docId, String status) async {
    await FirebaseFirestore.instance.collection('bookings').doc(docId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking status updated to "$status".')),
      );
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Reviews Tab
// ════════════════════════════════════════════════════════════════════════════

class _ReviewsTab extends StatelessWidget {
  const _ReviewsTab();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text('No reviews yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final rating = (data['rating'] as num?)?.toDouble() ?? 0;
            final comment = data['comment'] as String? ?? '';
            final entityType = data['entityType'] as String? ?? 'pandit';

            return Card(
              margin:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFF8E1),
                  child: Icon(Icons.star, color: Colors.amber),
                ),
                title: Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => Icon(
                        i < rating.round()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(entityType,
                          style: const TextStyle(fontSize: 11)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
                subtitle: Text(
                  comment.isEmpty ? '(no comment)' : comment,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'Delete review',
                  onPressed: () =>
                      _confirmDelete(context, docs[index].reference, 'review'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Announcements Tab
// ════════════════════════════════════════════════════════════════════════════

class _AnnouncementsTab extends StatefulWidget {
  const _AnnouncementsTab();

  @override
  State<_AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<_AnnouncementsTab> {
  final _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendAnnouncement() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() => _sending = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await AppNotificationService().sendAnnouncementToAll(message);
      _controller.clear();
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Announcement sent to all users!')),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to send announcement: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Send Announcement',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'This message will appear in every user\'s notification feed.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 6,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText: 'Type your announcement here…',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _sending ? null : _sendAnnouncement,
              icon: _sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_sending ? 'Sending…' : 'Send to All Users'),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Shared helper — confirmation dialog before delete
// ════════════════════════════════════════════════════════════════════════════

Future<void> _confirmDelete(
  BuildContext context,
  DocumentReference ref,
  String label,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete $label?'),
      content: const Text('This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete',
              style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  if (confirmed == true) {
    await ref.delete();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${label[0].toUpperCase()}${label.substring(1)} deleted.'),
        ),
      );
    }
  }
}
