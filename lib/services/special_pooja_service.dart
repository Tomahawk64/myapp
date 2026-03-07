
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/special_pooja.dart';
import 'firestore_service.dart';

class SpecialPoojaService extends FirestoreService<SpecialPooja> {
  SpecialPoojaService() : super(
    'special_poojas',
    (DocumentSnapshot doc) => SpecialPooja.fromFirestore(doc),
    (SpecialPooja pooja) => pooja.toJson(),
  );
}
