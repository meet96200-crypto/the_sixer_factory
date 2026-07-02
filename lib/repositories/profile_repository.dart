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

  Stream<UserModel?> profileStream(String uid) {
    return profileService.profileStream(uid);
  }
}
