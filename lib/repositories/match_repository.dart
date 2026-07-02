import 'dart:async';

import '../models/match_model.dart';
import '../services/api_service.dart';

class MatchRepositoryException implements Exception {
  const MatchRepositoryException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause == null) {
      return 'MatchRepositoryException: $message';
    }

    return 'MatchRepositoryException: $message ($cause)';
  }
}

class MatchRepository {
  MatchRepository({
    ApiService? apiService,
    this._timeout = const Duration(seconds: 15),
  })  : _apiService = apiService ?? ApiService();

  final ApiService _apiService;
  final Duration _timeout;

  Future<List<MatchModel>> getLiveMatches() {
    return _getMatches(
      request: _apiService.getLiveMatches,
      failureMessage: 'Unable to fetch live matches.',
      timeoutMessage: 'Fetching live matches timed out.',
    );
  }

  Future<List<MatchModel>> getUpcomingMatches() {
    return _getMatches(
      request: _apiService.getUpcomingMatches,
      failureMessage: 'Unable to fetch upcoming matches.',
      timeoutMessage: 'Fetching upcoming matches timed out.',
    );
  }

  Future<List<MatchModel>> _getMatches({
    required Future<List<MatchModel>> Function() request,
    required String failureMessage,
    required String timeoutMessage,
  }) async {
    try {
      return await request().timeout(
        _timeout,
        onTimeout: () => throw TimeoutException(timeoutMessage, _timeout),
      );
    } on TimeoutException catch (error) {
      throw MatchRepositoryException(timeoutMessage, error);
    } on MatchRepositoryException {
      rethrow;
    } catch (error) {
      throw MatchRepositoryException(failureMessage, error);
    }
  }
}