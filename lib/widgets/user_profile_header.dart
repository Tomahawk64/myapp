
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../screens/notification_center_screen.dart';
import '../services/app_notification_service.dart';
import '../services/auth_service.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────────────
          CircleAvatar(
            radius: 30,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 30)
                : null,
          ),
          const SizedBox(width: 16),

          // ── Name/email ───────────────────────────────────────────────────
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome',
                  style: Theme.of(context).textTheme.bodySmall),
              Text(
                user?.displayName ?? user?.email ?? 'Guest',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const Spacer(),

          // ── Notification bell with badge ─────────────────────────────────
          StreamBuilder<int>(
            stream: AppNotificationService().getUnreadCountStream(),
            builder: (context, snapshot) {
              final unread = snapshot.data ?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    tooltip: 'Notifications',
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationCenterScreen(),
                      ),
                    ),
                  ),
                  if (unread > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          // ── Logout ──────────────────────────────────────────────────────
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
    );
  }
}
