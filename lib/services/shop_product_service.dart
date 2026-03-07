
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shop_product.dart';
import 'firestore_service.dart';

class ShopProductService extends FirestoreService<ShopProduct> {
  ShopProductService() : super(
    'shop_products',
    (DocumentSnapshot doc) => ShopProduct.fromFirestore(doc),
    (ShopProduct product) => product.toJson(),
  );
}
