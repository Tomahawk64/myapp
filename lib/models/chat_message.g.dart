// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String?,
  sessionId: json['sessionId'] as String,
  senderId: json['senderId'] as String,
  messageType: $enumDecode(_$MessageTypeEnumMap, json['messageType']),
  messageText: json['messageText'] as String?,
  imageUrl: json['imageUrl'] as String?,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'senderId': instance.senderId,
      'messageType': _$MessageTypeEnumMap[instance.messageType]!,
      'messageText': instance.messageText,
      'imageUrl': instance.imageUrl,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
};
