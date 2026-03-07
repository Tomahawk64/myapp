
import 'package:flutter/material.dart';

import '../models/notification.dart';
import '../services/app_notification_service.dart';

/// Displays the signed-in user's in-app notification feed.
class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AppNotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: () async {
              await service.markAllAsRead();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All notifications marked as read.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: service.getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final notifications = snapshot.data ?? [];
          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No notifications yet',
                      style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            );
          }
          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return _NotificationTile(
                notification: notifications[index],
                onMarkRead: () =>
                    service.markAsRead(notifications[index].id),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onMarkRead;

  const _NotificationTile({
    required this.notification,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return ListTile(
      tileColor: unread
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.12)
          : null,
      leading: CircleAvatar(
        backgroundColor: unread
            ? Theme.of(context).colorScheme.primaryContainer
            : Colors.grey.shade200,
        child: Icon(
          Icons.notifications,
          color: unread ? primaryColor : Colors.grey,
          size: 20,
        ),
      ),
      title: Text(
        notification.message,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: unread ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          _timeAgo(notification.createdAt),
          style: const TextStyle(fontSize: 12),
        ),
      ),
      trailing: unread
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
            )
          : null,
      onTap: () {
        if (unread) onMarkRead();
      },
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
