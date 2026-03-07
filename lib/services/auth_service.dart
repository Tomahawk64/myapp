
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
      return AppUser.fromFirestore(doc.data() as Map<String, dynamic>?, user.uid);
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching user data: $e');
      return AppUser(uid: user.uid, email: user.email, role: UserRole.USER);
    }
  }

  // Auth change user stream
  Stream<AppUser?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebaseUser);
  }

  // Sign in with email & password
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        // Get device token and save it
        String? token = await _fcm.getToken();
        await _db.collection('users').doc(user.uid).update({'deviceToken': token});
            }
      return await _userFromFirebaseUser(user);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // Register with email & password
  Future<AppUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        // Get device token and save it
        String? token = await _fcm.getToken();

        // Create a new document for the user with the uid
        final newUser = AppUser(
          uid: user.uid,
          email: user.email,
          role: UserRole.USER, // Default role
          deviceToken: token,
        );
        await _db.collection('users').doc(user.uid).set(newUser.toFirestore());
        return newUser;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
