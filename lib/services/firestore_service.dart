
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final CollectionReference _collection;
  final T Function(DocumentSnapshot) _fromFirestore;
  final Map<String, dynamic> Function(T) _toFirestore;

  FirestoreService(String collectionPath, this._fromFirestore, this._toFirestore) : _collection = FirebaseFirestore.instance.collection(collectionPath);

  Future<void> create(T data) {
    final doc = _collection.doc();
    return doc.set(_toFirestore(data));
  }

  Stream<List<T>> getAll() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _fromFirestore(doc)).toList();
    });
  }

  Stream<T> get(String id) {
    return _collection.doc(id).snapshots().map((doc) => _fromFirestore(doc));
  }

  Future<void> update(String id, T data) {
    return _collection.doc(id).update(_toFirestore(data));
  }

  Future<void> delete(String id) {
    return _collection.doc(id).delete();
  }
}
