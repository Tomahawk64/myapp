// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pooja_package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PoojaPackage _$PoojaPackageFromJson(Map<String, dynamic> json) =>
    _PoojaPackage(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationInMinutes: (json['durationInMinutes'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String,
      isFeatured: json['isFeatured'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PoojaPackageToJson(_PoojaPackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'durationInMinutes': instance.durationInMinutes,
      'languages': instance.languages,
      'imageUrl': instance.imageUrl,
      'isFeatured': instance.isFeatured,
      'createdAt': instance.createdAt.toIso8601String(),
    };
