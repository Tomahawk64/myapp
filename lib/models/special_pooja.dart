
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'special_pooja.freezed.dart';
part 'special_pooja.g.dart';

@freezed
abstract class SpecialPooja with _$SpecialPooja {
  const factory SpecialPooja({
    required String id,
    required String name,
    required String description,
    required DateTime date,
    required String location,
    required double price,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SpecialPooja;

  factory SpecialPooja.fromJson(Map<String, dynamic> json) => _$SpecialPoojaFromJson(json);

  factory SpecialPooja.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return SpecialPooja.fromJson(data);
  }
}
