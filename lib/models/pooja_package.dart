
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pooja_package.freezed.dart';
part 'pooja_package.g.dart';

@freezed
abstract class PoojaPackage with _$PoojaPackage {
  const factory PoojaPackage({
    required String id,
    required String name,
    required String description,
    required double price,
    required int durationInMinutes,
    required List<String> languages,
    required String imageUrl,
    required bool isFeatured,
    required DateTime createdAt,
  }) = _PoojaPackage;

  factory PoojaPackage.fromJson(Map<String, dynamic> json) => _$PoojaPackageFromJson(json);

  factory PoojaPackage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] = (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    return PoojaPackage.fromJson(data);
  }
}
