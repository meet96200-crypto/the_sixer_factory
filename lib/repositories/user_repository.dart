import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({
    required this.userService,
  });

  Future<void> saveUser(UserModel user) {
    return userService.saveUser(user);
  }

  Future<UserModel?> getUser(String uid) {
    return userService.getUser(uid);
  }

  Future<void> updateUser(UserModel user) {
    return userService.updateUser(user);
  }
}
