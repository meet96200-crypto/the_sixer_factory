import 'dart:async';

import '../models/match_model.dart';
import '../services/api_service.dart';

class HomeRepository {
  HomeRepository({
    required ApiService apiService,
    Duration timeout = const Duration(seconds: 15),
  })  : _apiService = apiService,
        _timeout = timeout;

  final ApiService _apiService;
  final Duration _timeout;

  Future<List<MatchModel>> getLiveMatches() async {
    try {
      return await _apiService
          .getLiveMatches()
          .timeout(_timeout);
    } on TimeoutException {
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<List<MatchModel>> getUpcomingMatches() async {
    try {
      return await _apiService
          .getUpcomingMatches()
          .timeout(_timeout);
    } on TimeoutException {
      return [];
    } catch (_) {
      return [];
    }
  }
}