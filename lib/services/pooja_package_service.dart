
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pooja_package.dart';
import 'firestore_service.dart';

class PoojaPackageService extends FirestoreService<PoojaPackage> {
  PoojaPackageService() : super(
    'pooja_packages',
    (DocumentSnapshot doc) => PoojaPackage.fromFirestore(doc),
    (PoojaPackage package) => package.toFirestore(),
  );
}
