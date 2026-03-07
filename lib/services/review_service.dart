
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'reviews';

  // Create a new review
  Future<void> createReview(Review review) async {
    try {
      final docRef = _db.collection(_collectionPath).doc();
      await docRef.set(review.copyWith(id: docRef.id).toJson());
    } catch (e) {
      // ignore: avoid_print
      print('Error creating review: $e');
      rethrow;
    }
  }

  // Get all reviews for a specific pandit
  Stream<List<Review>> getPanditReviews(String panditId) {
    return _db
        .collection(_collectionPath)
        .where('panditId', isEqualTo: panditId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList());
  }

  // Get the average rating for a specific pandit
  Stream<double> getPanditAverageRating(String panditId) {
    return _db
        .collection(_collectionPath)
        .where('panditId', isEqualTo: panditId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return 0.0;
      }
      double sum = 0;
      for (var doc in snapshot.docs) {
        sum += (doc.data()['rating'] as num).toDouble();
      }
      return sum / snapshot.docs.length;
    });
  }
}
