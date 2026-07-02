import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository userRepository;

  UserProvider({
    required this.userRepository,
  });

  bool isLoading = false;
  UserModel? currentUser;

  Future<void> loadUser(String uid) async {
    isLoading = true;
    notifyListeners();

    currentUser = await userRepository.getUser(uid);

    isLoading = false;
    notifyListeners();
  }

  Future<void> saveUser(UserModel user) async {
    isLoading = true;
    notifyListeners();

    await userRepository.saveUser(user);
    currentUser = user;

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(UserModel user) async {
    isLoading = true;
    notifyListeners();

    await userRepository.updateUser(user);
    currentUser = user;

    isLoading = false;
    notifyListeners();
  }
}
