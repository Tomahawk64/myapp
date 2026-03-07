
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';
import 'firestore_service.dart';

class ChatMessageService extends FirestoreService<ChatMessage> {
  ChatMessageService() : super(
    'chat_messages',
    (DocumentSnapshot doc) => ChatMessage.fromFirestore(doc),
    (ChatMessage message) => message.toJson(),
  );
}
