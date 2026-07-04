import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app.dart';

// Services
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/profile_service.dart';
import 'services/search_service.dart';
import 'services/favorite_service.dart';
import 'services/news_service.dart';

// Repositories
import 'repositories/auth_repository.dart';
import 'repositories/home_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/profile_repository.dart';
import 'repositories/search_repository.dart';
import 'repositories/favorite_repository.dart';
import 'repositories/news_repository.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/user_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/search_provider.dart';
import 'providers/favorite_provider.dart';
import 'providers/news_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationService();
  await notificationService.initialize();
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
        Provider<SearchService>(
          create: (_) => SearchService(),
        ),
        Provider<FavoriteService>(
          create: (_) => FavoriteService(),
        ),
        Provider<NewsService>(
          create: (_) => NewsService(),
        ),
        Provider<NotificationService>(
          create: (_) => NotificationService(),
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
        Provider<SearchRepository>(
          create: (context) => SearchRepository(
            searchService: context.read<SearchService>(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            authService: context.read<AuthService>(),
          ),
        ),
        Provider<FavoriteRepository>(
          create: (context) => FavoriteRepository(
            favoriteService: context.read<FavoriteService>(),
          ),
        ),
        Provider<NewsRepository>(
          create: (context) => NewsRepository(
            newsService: context.read<NewsService>(),
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
        ChangeNotifierProvider<SearchProvider>(
          create: (context) => SearchProvider(
            searchRepository: context.read<SearchRepository>(),
          ),
        ),
        ChangeNotifierProvider<HomeProvider>(
          create: (context) => HomeProvider(
            homeRepository: context.read<HomeRepository>(),
          ),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (context) => FavoriteProvider(
            favoriteRepository: context.read<FavoriteRepository>(),
          ),
        ),
        ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(
            newsRepository: context.read<NewsRepository>(),
          )..loadNews(),
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