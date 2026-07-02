import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthProvider({
    required this.authRepository,
  });

  bool isLoading = false;

  User? get currentUser => authRepository.currentUser;

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await authRepository.login(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await authRepository.register(
        email: email,
        password: password,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Error: ${e.code}");
      debugPrint("Message: ${e.message}");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
  }
}