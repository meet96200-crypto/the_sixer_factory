import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier {
  final NewsRepository newsRepository;

  NewsProvider({
    required this.newsRepository,
  });

  bool _isLoading = false;
  String _error = '';

  List<NewsModel> _news = [];

  bool get isLoading => _isLoading;
  String get error => _error;
  List<NewsModel> get news => _news;

  // ===============================
  // Load News
  // ===============================
  Future<void> loadNews() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _news = await newsRepository.getNews();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===============================
  // Live Stream
  // ===============================
  Stream<List<NewsModel>> newsStream() {
    return newsRepository.newsStream();
  }

  // ===============================
  // Refresh
  // ===============================
  Future<void> refresh() async {
    await loadNews();
  }

  // ===============================
  // Add News
  // ===============================
  Future<void> addNews(NewsModel news) async {
    try {
      await newsRepository.addNews(news);
      await loadNews();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===============================
  // Update News
  // ===============================
  Future<void> updateNews(NewsModel news) async {
    try {
      await newsRepository.updateNews(news);
      await loadNews();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // ===============================
  // Delete News
  // ===============================
  Future<void> deleteNews(String id) async {
    try {
      await newsRepository.deleteNews(id);
      await loadNews();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}