
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/notification.dart';

/// Service for in-app notification management (Firestore `notifications`
/// collection). Distinct from FCM push notifications.
class AppNotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Writes a notification document for [userId].
  Future<void> sendNotification({
    required String userId,
    required String message,
  }) async {
    await _db.collection('notifications').add({
      'userId': userId,
      'message': message,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Sends an announcement to every user in the `users` collection.
  /// Uses a batched write for atomicity (max 500 users per batch).
  Future<void> sendAnnouncementToAll(String message) async {
    final usersSnapshot = await _db.collection('users').get();
    final List<List<QueryDocumentSnapshot>> chunks = [];

    // Split into batches of 500 (Firestore limit)
    for (var i = 0; i < usersSnapshot.docs.length; i += 500) {
      chunks.add(usersSnapshot.docs.sublist(
        i,
        i + 500 > usersSnapshot.docs.length
            ? usersSnapshot.docs.length
            : i + 500,
      ));
    }

    for (final chunk in chunks) {
      final batch = _db.batch();
      for (final userDoc in chunk) {
        final notifRef = _db.collection('notifications').doc();
        batch.set(notifRef, {
          'userId': userDoc.id,
          'message': message,
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    }
  }

  /// Stream of notifications for the currently signed-in user, newest first.
  Stream<List<AppNotification>> getUserNotifications() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromFirestore(doc))
            .toList());
  }

  /// Marks a single notification document as read.
  Future<void> markAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({
      'isRead': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Marks all unread notifications for the current user as read.
  Future<void> markAllAsRead() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final unread = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  /// Returns a stream of the unread notification count for the current user.
  Stream<int> getUnreadCountStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return const Stream.empty();

    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
