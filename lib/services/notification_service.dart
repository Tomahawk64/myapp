
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Top-level background handler — must be a top-level function, not a method.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background messages are displayed by the OS automatically.
}

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const _androidChannel = AndroidNotificationChannel(
  'pandit_app_high_importance',
  'Pandit App Notifications',
  description: 'Notifications for bookings, consultations and orders.',
  importance: Importance.high,
);

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      _fcm.getToken().then((token) {
        if (token != null) saveTokenToDatabase(token);
      });
      _fcm.onTokenRefresh.listen(saveTokenToDatabase);

      if (!kIsWeb) {
        await _initLocalNotifications();
        FirebaseMessaging.onMessage.listen(_showForegroundNotification);
      }
    }
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );
    await _localNotificationsPlugin.initialize(initSettings);

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> saveTokenToDatabase(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'deviceToken': token});
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }
}
