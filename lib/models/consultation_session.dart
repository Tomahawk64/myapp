
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'consultation_session.freezed.dart';
part 'consultation_session.g.dart';

@freezed
abstract class ConsultationSession with _$ConsultationSession {
  const factory ConsultationSession({
    required String id,
    required String userId,
    required String panditId,
    required DateTime startTime,
    DateTime? endTime,
    required int durationMinutes,
    required String status, // e.g., 'scheduled', 'completed', 'cancelled'
    String? channelId, // For Agora or other video call service
    required DateTime createdAt,
  }) = _ConsultationSession;

  factory ConsultationSession.fromJson(Map<String, dynamic> json) => _$ConsultationSessionFromJson(json);

  factory ConsultationSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return ConsultationSession.fromJson(data);
  }
}
