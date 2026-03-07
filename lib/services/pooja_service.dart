
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pooja_package.dart';

class PoojaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PoojaPackage>> getPoojas() {
    return _db.collection('poojas').snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PoojaPackage.fromFirestore(doc))
        .toList());
  }
}
