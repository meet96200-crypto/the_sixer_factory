import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/news_model.dart';

class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get All News
  Future<List<NewsModel>> getNews() async {
    final snapshot = await _firestore
        .collection('news')
        .orderBy('publishedAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return NewsModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  // Live Stream
  Stream<List<NewsModel>> newsStream() {
    return _firestore
        .collection('news')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
        return NewsModel.fromMap(doc.data(), doc.id);
      }).toList(),
    );
  }

  // Add News
  Future<void> addNews(NewsModel news) async {
    await _firestore.collection('news').add(news.toMap());
  }

  // Update News
  Future<void> updateNews(NewsModel news) async {
    await _firestore
        .collection('news')
        .doc(news.id)
        .update(news.toMap());
  }

  // Delete News
  Future<void> deleteNews(String id) async {
    await _firestore
        .collection('news')
        .doc(id)
        .delete();
  }
}