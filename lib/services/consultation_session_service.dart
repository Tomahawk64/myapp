
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';
import '../models/consultation_session.dart';
import '../models/consultation_status.dart';

class ConsultationSessionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _sessionsCollection = 'consultation_sessions';
  final String _messagesCollection = 'chat_messages';

  /// Creates a new consultation session in Firestore.
  Future<ConsultationSession> createSession(String userId, String panditId, int duration, double price) async {
    final sessionData = {
      'userId': userId,
      'panditId': panditId,
      'durationMinutes': duration,
      'price': price,
      'status': ConsultationStatus.pending.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    final docRef = await _db.collection(_sessionsCollection).add(sessionData);
    final newDoc = await docRef.get();
    return ConsultationSession.fromFirestore(newDoc);
  }

  /// Initiates a consultation session.
  Future<void> startSession(String sessionId) async {
    final sessionRef = _db.collection(_sessionsCollection).doc(sessionId);
    final sessionDoc = await sessionRef.get();
    if (!sessionDoc.exists) {
      throw Exception("Session not found!");
    }
    final session = ConsultationSession.fromFirestore(sessionDoc);

    final now = DateTime.now();
    final endTime = now.add(Duration(minutes: session.durationMinutes));

    await sessionRef.update({
      'status': ConsultationStatus.active.name,
      'startTime': Timestamp.fromDate(now),
      'endTime': Timestamp.fromDate(endTime),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Sends a chat message, but only if the session is currently active.
  Future<void> sendMessage(ChatMessage message) async {
    final sessionDoc = await _db.collection(_sessionsCollection).doc(message.sessionId).get();
    if (!sessionDoc.exists) {
      throw Exception('Session does not exist.');
    }
    final session = ConsultationSession.fromFirestore(sessionDoc);

    if (session.status != ConsultationStatus.active.name ||
        session.endTime == null ||
        DateTime.now().isAfter(session.endTime!)) {
      throw Exception('This consultation session is not active.');
    }

    await _db.collection(_messagesCollection).add(message.toJson());
  }

  /// Retrieves a stream of all messages for a given session.
  Stream<List<ChatMessage>> getMessages(String sessionId) {
    return _db
        .collection(_messagesCollection)
        .where('sessionId', isEqualTo: sessionId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList());
  }

  /// Extends an active consultation session by a given number of minutes.
  Future<void> extendSession(String sessionId, int extraMinutes) async {
    final sessionRef = _db.collection(_sessionsCollection).doc(sessionId);

    return _db.runTransaction((transaction) async {
      final sessionSnap = await transaction.get(sessionRef);
      if (!sessionSnap.exists) {
        throw Exception("Session not found");
      }
      final session = ConsultationSession.fromFirestore(sessionSnap);

      if (session.status == ConsultationStatus.active.name && session.endTime != null) {
        final newEndTime = session.endTime!.add(Duration(minutes: extraMinutes));
        transaction.update(sessionRef, {
          'endTime': Timestamp.fromDate(newEndTime),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  /// Ends a consultation session, updating its status.
  Future<void> endSession(String sessionId, ConsultationStatus status) async {
    await _db.collection(_sessionsCollection).doc(sessionId).update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Retrieves a real-time stream for a single consultation session.
  Stream<ConsultationSession?> getSessionStream(String sessionId) {
    return _db
        .collection(_sessionsCollection)
        .doc(sessionId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        return null;
      }
      return ConsultationSession.fromFirestore(doc);
    });
  }

  /// Retrieves all consultation sessions for a specific user.
  Stream<List<ConsultationSession>> getUserSessions(String userId) {
    return _db
        .collection(_sessionsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultationSession.fromFirestore(doc))
            .toList());
  }

  /// Retrieves all consultation sessions for a specific pandit.
  Stream<List<ConsultationSession>> getPanditSessions(String panditId) {
    return _db
        .collection(_sessionsCollection)
        .where('panditId', isEqualTo: panditId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultationSession.fromFirestore(doc))
            .toList());
  }
}
