import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository({
    required this.authService,
  });

  User? get currentUser => authService.currentUser;

  Stream<User?> get authStateChanges => authService.authStateChanges;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return authService.signIn(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) {
    return authService.register(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return authService.logout();
  }
}