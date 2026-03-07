// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pandit_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PanditProfile _$PanditProfileFromJson(Map<String, dynamic> json) =>
    _PanditProfile(
      id: json['id'] as String,
      bio: json['bio'] as String,
      specialities: (json['specialities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      experience: (json['experience'] as num).toInt(),
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      location: json['location'] as String,
      isVerified: json['isVerified'] as bool,
      rating: (json['rating'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PanditProfileToJson(_PanditProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bio': instance.bio,
      'specialities': instance.specialities,
      'experience': instance.experience,
      'languages': instance.languages,
      'location': instance.location,
      'isVerified': instance.isVerified,
      'rating': instance.rating,
      'createdAt': instance.createdAt.toIso8601String(),
    };
