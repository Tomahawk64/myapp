// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShopProduct _$ShopProductFromJson(Map<String, dynamic> json) => _ShopProduct(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String,
  stock: (json['stock'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ShopProductToJson(_ShopProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'stock': instance.stock,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
