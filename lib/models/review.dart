
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
abstract class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    required String entityId, // Can be panditId, poojaId, etc.
    required String entityType, // 'pandit', 'pooja'
    required double rating,
    required String comment,
    required DateTime createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    return Review.fromJson(data);
  }
}
