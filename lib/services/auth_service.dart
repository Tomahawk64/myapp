
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Create AppUser object from Firebase User and Firestore document
  Future<AppUser?> _userFromFirebaseUser(User? user) async {
    if (user == null) {
      return null;
    }
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        role: UserRole.user,
        createdAt: DateTime.now(),
      );
    } catch (e) {
      return AppUser(
        id: user.uid,
        email: user.email ?? '',
        role: UserRole.user,
        createdAt: DateTime.now(),
      );
    }
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Sign in with email & password
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user;
    if (user != null) {
      try {
        final token = await _fcm.getToken();
        await _db.collection('users').doc(user.uid).update({'deviceToken': token});
      } catch (_) {}
    }
    return await _userFromFirebaseUser(user);
  }

  // Register with email & password
  Future<AppUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = result.user;
    if (user != null) {
      // Get device token and save it
      final token = await _fcm.getToken();

      // Create a new document for the user with the uid
      final newUser = AppUser(
        id: user.uid,
        email: user.email ?? '',
        role: UserRole.user,
        createdAt: DateTime.now(),
        deviceToken: token,
      );
      await _db.collection('users').doc(user.uid).set(newUser.toJson());
      return newUser;
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
