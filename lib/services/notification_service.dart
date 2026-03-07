
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permission for iOS and web
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      _fcm.getToken().then((token) {
        if (token != null) {
          saveTokenToDatabase(token);
        }
      });

      // Listen for token refresh
      _fcm.onTokenRefresh.listen(saveTokenToDatabase);

      // Handle incoming messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: \${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: \${message.notification}');
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'deviceToken': token,
    });
    }
}
