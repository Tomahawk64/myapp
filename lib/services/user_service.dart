
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import 'firestore_service.dart';

class UserService extends FirestoreService<AppUser> {
  UserService() : super(
    'users',
    (DocumentSnapshot doc) => AppUser.fromFirestore(doc),
    (AppUser user) => user.toJson(),
  );
}
