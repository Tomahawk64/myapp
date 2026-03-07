
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pandit_profile.dart';
import 'firestore_service.dart';

class PanditProfileService extends FirestoreService<PanditProfile> {
  PanditProfileService() : super(
    'pandit_profiles',
    (DocumentSnapshot doc) => PanditProfile.fromFirestore(doc),
    (PanditProfile profile) => profile.toJson(),
  );
}
