import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../models/user_model.dart';
import '../repositories/search_repository.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRepository searchRepository;

  SearchProvider({
    required this.searchRepository,
  });

  bool _isLoading = false;
  String _error = '';

  List<UserModel> _users = [];
  List<MatchModel> _matches = [];

  bool get isLoading => _isLoading;
  String get error => _error;

  List<UserModel> get users => _users;
  List<MatchModel> get matches => _matches;

  Future<void> search({
    required String query,
    required List<MatchModel> allMatches,
  }) async {
    if (query.trim().isEmpty) {
      _users = [];
      _matches = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _users = await searchRepository.searchUsers(query);

      _matches = await searchRepository.searchMatches(
        query,
        allMatches,
      );
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _users = [];
    _matches = [];
    _error = '';
    notifyListeners();
  }
}