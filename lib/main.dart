import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app.dart';

// Services
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/profile_service.dart';

// Repositories
import 'repositories/auth_repository.dart';
import 'repositories/home_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/profile_repository.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/user_provider.dart';
import 'providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [

        // ==========================
        // SERVICES
        // ==========================

        Provider<ApiService>(
          create: (_) => ApiService(),
        ),

        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

        Provider<UserService>(
          create: (_) => UserService(),
        ),

        Provider<ProfileService>(
          create: (_) => ProfileService(),
        ),

        // ==========================
        // REPOSITORIES
        // ==========================

        Provider<UserRepository>(
          create: (context) => UserRepository(
            userService: context.read<UserService>(),
          ),
        ),

        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
            profileService: context.read<ProfileService>(),
          ),
        ),

        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            authService: context.read<AuthService>(),
          ),
        ),

        Provider<HomeRepository>(
          create: (context) => HomeRepository(
            apiService: context.read<ApiService>(),
          ),
        ),

        // ==========================
        // PROVIDERS
        // ==========================

        ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider(
            userRepository: context.read<UserRepository>(),
          ),
        ),

        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(
            profileRepository: context.read<ProfileRepository>(),
          ),
        ),

        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            homeRepository: context.read<HomeRepository>(),
          )..loadHomeData(),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
      ],

      child: const TheSixerFactoryApp(),
    ),
  );
}