
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required String userId,
    required String message,
    required bool isRead,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }
    data['createdAt'] ??= DateTime.now().toIso8601String();
    data['updatedAt'] ??= DateTime.now().toIso8601String();
    return AppNotification.fromJson(data);
  }
}
