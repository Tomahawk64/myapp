// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  userId: json['userId'] as String,
  panditId: json['panditId'] as String?,
  poojaId: json['poojaId'] as String,
  date: DateTime.parse(json['date'] as String),
  status: $enumDecode(_$BookingStatusEnumMap, json['status']),
  bookingType: $enumDecode(_$BookingTypeEnumMap, json['bookingType']),
  paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
  price: (json['price'] as num).toDouble(),
  address: json['address'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  transactionId: json['transactionId'] as String?,
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'panditId': instance.panditId,
  'poojaId': instance.poojaId,
  'date': instance.date.toIso8601String(),
  'status': _$BookingStatusEnumMap[instance.status]!,
  'bookingType': _$BookingTypeEnumMap[instance.bookingType]!,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'price': instance.price,
  'address': instance.address,
  'createdAt': instance.createdAt.toIso8601String(),
  'transactionId': instance.transactionId,
};

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.assigned: 'assigned',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
};

const _$BookingTypeEnumMap = {
  BookingType.online: 'online',
  BookingType.offline: 'offline',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
};
