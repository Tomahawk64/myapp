
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'bookings';

  // Create a new booking
  Future<Booking> createBooking(Booking booking) async {
    try {
      final docRef = _db.collection(_collectionPath).doc();
      final newBooking = booking.copyWith(id: docRef.id);
      await docRef.set(newBooking.toJson());
      return newBooking;
    } catch (e) {
      // ignore: avoid_print
      print('Error creating booking: $e');
      rethrow;
    }
  }

  // Assign a pandit to a booking
  Future<void> assignPandit(String bookingId, String panditId) async {
    try {
      await _db.collection(_collectionPath).doc(bookingId).update({
        'panditId': panditId,
        'status': BookingStatus.assigned.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error assigning pandit: $e');
      rethrow;
    }
  }

  // Update booking status
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    try {
      await _db.collection(_collectionPath).doc(bookingId).update({
        'status': status.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  Future<void> updateBookingPaymentStatus(String bookingId, PaymentStatus status, [String? paymentId]) async {
    try {
      final updateData = {
        'paymentStatus': status.toString(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (paymentId != null) {
        updateData['paymentId'] = paymentId;
      }
      await _db.collection(_collectionPath).doc(bookingId).update(updateData);
    } catch (e) {
      // ignore: avoid_print
      print('Error updating booking payment status: $e');
      rethrow;
    }
  }


  // Get all bookings for a specific user
  Stream<List<Booking>> getUserBookings(String userId) {
    return _db
        .collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson(doc.data()))
            .toList());
  }

  // Get all bookings assigned to a specific pandit
  Stream<List<Booking>> getPanditBookings(String panditId) {
    return _db
        .collection(_collectionPath)
        .where('panditId', isEqualTo: panditId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson(doc.data()))
            .toList());
  }
  
  // Get all available bookings for pandits to view
  Stream<List<Booking>> getAvailableBookings() {
    return _db
        .collection(_collectionPath)
        .where('status', isEqualTo: BookingStatus.pending.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromJson(doc.data()))
            .toList());
  }
}
