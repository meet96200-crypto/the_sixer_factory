import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../services/api_service.dart';

class LiveMatchProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String _error = "";

  List<MatchModel> _matches = [];

  bool get isLoading => _isLoading;

  String get error => _error;

  List<MatchModel> get matches => _matches;

  Future<void> loadMatches() async {
    try {
      _isLoading = true;
      _error = "";
      notifyListeners();

      _matches = await _apiService.getLiveMatches();

    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}