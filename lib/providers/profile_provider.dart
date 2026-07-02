import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepository profileRepository;

  ProfileProvider({
    required this.profileRepository,
  });

  UserModel? _user;
  bool _isLoading = false;
  String _error = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadProfile(String uid) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _user = await profileRepository.getProfile(uid);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await profileRepository.updateProfile(updatedUser);
      _user = updatedUser;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Stream<UserModel?> profileStream(String uid) {
    return profileRepository.profileStream(uid);
  }

  void clearProfile() {
    _user = null;
    _error = '';
    notifyListeners();
  }
}
