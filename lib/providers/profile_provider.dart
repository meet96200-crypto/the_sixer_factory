import 'dart:typed_data';

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
  bool _isUploadingPhoto = false;
  double _photoUploadProgress = 0;
  String _error = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isUploadingPhoto => _isUploadingPhoto;
  double get photoUploadProgress => _photoUploadProgress;
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

  Future<String?> uploadProfilePhoto({
    required String uid,
    required Uint8List imageBytes,
  }) async {
    _isUploadingPhoto = true;
    _photoUploadProgress = 0;
    _error = '';
    notifyListeners();

    try {
      final photoUrl = await profileRepository.uploadProfileImage(
        uid: uid,
        imageBytes: imageBytes,
        onProgress: (progress) {
          _photoUploadProgress = progress.clamp(0, 1).toDouble();
          notifyListeners();
        },
      );

      _user = _user?.copyWith(
        photoUrl: photoUrl,
        updatedAt: DateTime.now(),
      );
      _user = await profileRepository.getProfile(uid) ?? _user;
      return photoUrl;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _isUploadingPhoto = false;
      _photoUploadProgress = 0;
      notifyListeners();
    }
  }

  Stream<UserModel?> profileStream(String uid) {
    return profileRepository.profileStream(uid);
  }

  void clearProfile() {
    _user = null;
    _isUploadingPhoto = false;
    _photoUploadProgress = 0;
    _error = '';
    notifyListeners();
  }
}
