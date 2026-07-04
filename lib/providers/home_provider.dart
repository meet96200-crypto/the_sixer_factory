import 'dart:async';

import 'package:flutter/material.dart';

import '../models/match_model.dart';
import '../repositories/home_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required HomeRepository homeRepository,
  }) : _homeRepository = homeRepository {
    loadHomeData();
    startAutoRefresh();
  }

  final HomeRepository _homeRepository;
  Timer? _refreshTimer;

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
  void startAutoRefresh() {
    _refreshTimer?.cancel();

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
          (timer) {
        loadHomeData();
      },
    );
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
  }
  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}