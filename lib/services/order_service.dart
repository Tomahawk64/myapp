
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order.dart';
import 'firestore_service.dart';

class OrderService extends FirestoreService<AppOrder> {
  OrderService() : super(
    'orders',
    (DocumentSnapshot doc) => AppOrder.fromFirestore(doc),
    (AppOrder order) => order.toJson(),
  );
}
