import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favoritesRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');
  }

  /// Add Favorite
  Future<void> addFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) async {
    await _favoritesRef(uid).doc('${type}_$itemId').set({
      'type': type,
      'itemId': itemId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove Favorite
  Future<void> removeFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) async {
    await _favoritesRef(uid).doc('${type}_$itemId').delete();
  }

  /// Check Favorite
  Future<bool> isFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) async {
    final doc =
    await _favoritesRef(uid).doc('${type}_$itemId').get();

    return doc.exists;
  }

  /// Stream Favorites of a specific type
  Stream<List<String>> getFavorites({
    required String uid,
    required String type,
  }) {
    return _favoritesRef(uid)
        .where('type', isEqualTo: type)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['itemId'] as String)
          .toList();
    });
  }
}