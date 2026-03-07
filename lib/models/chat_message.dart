
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum MessageType { text, image }

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    String? id,
    required String sessionId,
    required String senderId,
    required MessageType messageType,
    String? messageText,
    String? imageUrl,
    required DateTime timestamp,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage.fromJson(data).copyWith(id: doc.id);
  }
}
