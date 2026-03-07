// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consultation_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsultationSession _$ConsultationSessionFromJson(Map<String, dynamic> json) =>
    _ConsultationSession(
      id: json['id'] as String,
      userId: json['userId'] as String,
      panditId: json['panditId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      status: json['status'] as String,
      channelId: json['channelId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ConsultationSessionToJson(
  _ConsultationSession instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'panditId': instance.panditId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'status': instance.status,
  'channelId': instance.channelId,
  'createdAt': instance.createdAt.toIso8601String(),
};
