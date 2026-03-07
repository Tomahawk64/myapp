// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'special_pooja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpecialPooja _$SpecialPoojaFromJson(Map<String, dynamic> json) =>
    _SpecialPooja(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      location: json['location'] as String,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SpecialPoojaToJson(_SpecialPooja instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'date': instance.date.toIso8601String(),
      'location': instance.location,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
