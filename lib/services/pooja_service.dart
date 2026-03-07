
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pooja.dart';

class PoojaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Pooja>> getPoojas() {
    return _db.collection('poojas').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Pooja.fromMap(doc.data()))
        .toList());
  }
}
