
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'shop_product.freezed.dart';
part 'shop_product.g.dart';

@freezed
abstract class ShopProduct with _$ShopProduct {
  const factory ShopProduct({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required int stock,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ShopProduct;

  factory ShopProduct.fromJson(Map<String, dynamic> json) => _$ShopProductFromJson(json);

  factory ShopProduct.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return ShopProduct.fromJson(data);
  }
}
