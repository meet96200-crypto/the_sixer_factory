import 'package:flutter/material.dart';

import '../repositories/favorite_repository.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteRepository favoriteRepository;

  FavoriteProvider({
    required this.favoriteRepository,
  });

  bool _isLoading = false;
  String _error = '';

  List<String> _favoriteMatches = [];
  List<String> _favoriteNews = [];
  List<String> _favoriteVideos = [];

  bool get isLoading => _isLoading;
  String get error => _error;

  List<String> get favoriteMatches => _favoriteMatches;
  List<String> get favoriteNews => _favoriteNews;
  List<String> get favoriteVideos => _favoriteVideos;

  Future<void> addFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) async {
    try {
      await favoriteRepository.addFavorite(
        uid: uid,
        type: type,
        itemId: itemId,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) async {
    try {
      await favoriteRepository.removeFavorite(
        uid: uid,
        type: type,
        itemId: itemId,
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> isFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) {
    return favoriteRepository.isFavorite(
      uid: uid,
      type: type,
      itemId: itemId,
    );
  }

  void listenFavorites({
    required String uid,
  }) {
    favoriteRepository
        .getFavorites(uid: uid, type: 'match')
        .listen((data) {
      _favoriteMatches = data;
      notifyListeners();
    });

    favoriteRepository
        .getFavorites(uid: uid, type: 'news')
        .listen((data) {
      _favoriteNews = data;
      notifyListeners();
    });

    favoriteRepository
        .getFavorites(uid: uid, type: 'video')
        .listen((data) {
      _favoriteVideos = data;
      notifyListeners();
    });
  }

  bool isMatchFavorite(String id) {
    return _favoriteMatches.contains(id);
  }

  bool isNewsFavorite(String id) {
    return _favoriteNews.contains(id);
  }

  bool isVideoFavorite(String id) {
    return _favoriteVideos.contains(id);
  }
}