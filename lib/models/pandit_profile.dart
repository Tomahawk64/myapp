
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pandit_profile.freezed.dart';
part 'pandit_profile.g.dart';

@freezed
abstract class PanditProfile with _$PanditProfile {
  const factory PanditProfile({
    required String id, // Corresponds to the AppUser ID
    required String bio,
    required List<String> specialities,
    required int experience, // Years of experience
    required List<String> languages,
    required String location,
    required bool isVerified,
    double? rating,
    required DateTime createdAt,
  }) = _PanditProfile;

  factory PanditProfile.fromJson(Map<String, dynamic> json) => _$PanditProfileFromJson(json);

    factory PanditProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    return PanditProfile.fromJson(data);
  }
}
