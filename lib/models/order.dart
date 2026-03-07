
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
abstract class AppOrder with _$AppOrder {
  const factory AppOrder({
    required String id,
    required String userId,
    required List<String> productIds,
    required double totalPrice,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppOrder;

  factory AppOrder.fromJson(Map<String, dynamic> json) => _$AppOrderFromJson(json);

  factory AppOrder.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return AppOrder.fromJson(data);
  }
}
