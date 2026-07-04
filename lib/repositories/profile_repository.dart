import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileRepository {
  final ProfileService profileService;

  ProfileRepository({
    required this.profileService,
  });

  Future<UserModel?> getProfile(String uid) {
    return profileService.getProfile(uid);
  }

  Future<void> updateProfile(UserModel user) {
    return profileService.updateProfile(user);
  }

  Future<String> uploadProfileImage({
    required String uid,
    required Uint8List imageBytes,
    ValueChanged<double>? onProgress,
  }) {
    return profileService.uploadProfileImage(
      uid: uid,
      imageBytes: imageBytes,
      onProgress: onProgress,
    );
  }

  Stream<UserModel?> profileStream(String uid) {
    return profileService.profileStream(uid);
  }
}
