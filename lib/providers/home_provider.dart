import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository;

  final HomeRepository _homeRepository;

  bool _isLoading = false;
  String _error = '';

  List<MatchModel> _liveMatches = [];
  List<MatchModel> _upcomingMatches = [];

  bool get isLoading => _isLoading;

  String get error => _error;

  List<MatchModel> get liveMatches => _liveMatches;

  List<MatchModel> get upcomingMatches => _upcomingMatches;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _liveMatches = await _homeRepository.getLiveMatches();
      _upcomingMatches = await _homeRepository.getUpcomingMatches();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadHomeData();
  }
}