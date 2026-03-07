
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

// Enums must be declared outside the class for freezed
enum BookingStatus { pending, confirmed, assigned, completed, cancelled }
enum BookingType { online, offline }
enum PaymentStatus { pending, completed, failed }

@freezed
abstract class Booking with _$Booking {
  // Adding a comment to trigger build_runner
  const factory Booking({
    required String id,
    required String userId,
    String? panditId,
    required String poojaId, // Refers to a PoojaPackage
    required DateTime date,
    required BookingStatus status,
    required BookingType bookingType,
    required PaymentStatus paymentStatus,
    required double price,
    String? address,
    required DateTime createdAt,
    String? transactionId, // For payment tracking
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    data['id'] = doc.id;
    return Booking.fromJson(data);
  }
}
