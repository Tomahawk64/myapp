
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pandit_profile.dart';

class PanditService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PanditProfile>> getPandits() {
    return _db.collection('pandits').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => PanditProfile.fromJson(doc.data())).toList());
  }
}
