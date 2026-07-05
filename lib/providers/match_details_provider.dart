import 'package:flutter/material.dart';

import '../models/match_details_model.dart';
import '../repositories/home_repository.dart';

class MatchDetailsProvider extends ChangeNotifier {
  MatchDetailsProvider({
    required HomeRepository repository,
  }) : _repository = repository;

  final HomeRepository _repository;

  bool _loading = false;

  bool get loading => _loading;

  MatchDetailsModel? _match;

  MatchDetailsModel? get match => _match;

  String _error = "";

  String get error => _error;

  Future<void> loadMatch(String matchId) async {
    _loading = true;
    _error = "";

    notifyListeners();

    try {
      final json = await _repository.getMatchDetails(matchId);

      _match = MatchDetailsModel.fromJson(json);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;

    notifyListeners();
  }
}