import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../settings/settings_screen.dart';

import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import 'edit_profile_screen.dart';
import '../admin/admin_dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final auth = context.read<AuthProvider>();
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) return;

    await context.read<ProfileProvider>().loadProfile(firebaseUser.uid);
  }

  Future<void> _openEditProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditProfileScreen(),
      ),
    );

    if (!mounted) return;
    await _loadProfile();
  }

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      context.read<ProfileProvider>().clearProfile();
      await context.read<AuthProvider>().logout();
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final firebaseUser = auth.currentUser;
    final profile = profileProvider.user;

    final isInitialLoading = profileProvider.isLoading && profile == null;
    final hasBlockingError = profileProvider.error.isNotEmpty && profile == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            if (profileProvider.isLoading && profile != null)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(),
              ),
            if (isInitialLoading)
              const _CenteredProfileState(
                icon: Icons.person_search_outlined,
                title: 'Loading profile',
                message: 'Getting your cricket profile ready...',
                child: Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (hasBlockingError)
              _CenteredProfileState(
                icon: Icons.error_outline,
                title: 'Could not load profile',
                message: _cleanError(profileProvider.error),
                child: Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: FilledButton.icon(
                    onPressed: _loadProfile,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ),
              )
            else if (firebaseUser == null)
                const _CenteredProfileState(
                  icon: Icons.lock_outline,
                  title: 'You are signed out',
                  message: 'Sign in again to view your profile.',
                )
              else
                _ProfileContent(
                  profile: profile,
                  fallbackName: firebaseUser.displayName,
                  fallbackEmail: firebaseUser.email,
                  fallbackPhotoUrl: firebaseUser.photoURL,
                  errorMessage: profileProvider.error,
                  isLoggingOut: _isLoggingOut,
                  onEditProfile: _openEditProfile,
                  onLogout: _logout,
                ),
          ],
        ),
      ),
    );
  }

  String _cleanError(String error) {
    if (error.trim().isEmpty) return 'Something went wrong.';
    return error.replaceFirst('Exception: ', '').trim();
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.profile,
    required this.fallbackName,
    required this.fallbackEmail,
    required this.fallbackPhotoUrl,
    required this.errorMessage,
    required this.isLoggingOut,
    required this.onEditProfile,
    required this.onLogout,
  });

  final UserModel? profile;
  final String? fallbackName;
  final String? fallbackEmail;
  final String? fallbackPhotoUrl;
  final String errorMessage;
  final bool isLoggingOut;
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = _valueOrFallback(profile?.name, fallbackName, 'Cricket Fan');
    final email = _valueOrFallback(profile?.email, fallbackEmail, 'No email');
    final bio = _valueOrFallback(
      profile?.bio,
      null,
      'No bio added yet.',
    );
    final country = _valueOrFallback(profile?.country, null, 'Not selected');
    final favoriteTeam = _valueOrFallback(
      profile?.favoriteTeam,
      null,
      'Not selected',
    );
    final favoritePlayer = _valueOrFallback(
      profile?.favoritePlayer,
      null,
      'Not selected',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        errorMessage.replaceFirst('Exception: ', ''),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Card(
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 22),
            child: Column(
              children: [
                _ProfileAvatar(
                  photoUrl: _valueOrNull(profile?.photoUrl) ?? fallbackPhotoUrl,
                  name: name,
                ),
                const SizedBox(height: 18),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _InfoTile(
          icon: Icons.public,
          title: 'Country',
          value: country,
        ),
        _InfoTile(
          icon: Icons.favorite_outline,
          title: 'Favorite Team',
          value: favoriteTeam,
        ),
        _InfoTile(
          icon: Icons.star_outline,
          title: 'Favorite Player',
          value: favoritePlayer,
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onEditProfile,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Edit Profile'),
        ),
        const SizedBox(height: 12),

        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminDashboard(),
              ),
            );
          },
          icon: const Icon(Icons.admin_panel_settings),
          label: const Text("Admin Panel"),
        ),

        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(Icons.settings),
          label: const Text("Settings"),
        ),

        const SizedBox(height: 12),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: isLoggingOut ? null : onLogout,
          icon: isLoggingOut
              ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Icon(Icons.logout),
          label: Text(isLoggingOut ? 'Logging out...' : 'Logout'),
        ),
      ],
    );
  }

  String _valueOrFallback(String? value, String? fallback, String emptyText) {
    final trimmedValue = value?.trim();
    if (trimmedValue != null && trimmedValue.isNotEmpty) {
      return trimmedValue;
    }

    final trimmedFallback = fallback?.trim();
    if (trimmedFallback != null && trimmedFallback.isNotEmpty) {
      return trimmedFallback;
    }

    return emptyText;
  }

  String? _valueOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
    required this.photoUrl,
    required this.name,
  });

  final String? photoUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

    return CircleAvatar(
      radius: 54,
      backgroundColor: theme.colorScheme.primaryContainer,
      backgroundImage: photoUrl == null || photoUrl!.trim().isEmpty
          ? null
          : NetworkImage(photoUrl!.trim()),
      child: photoUrl == null || photoUrl!.trim().isEmpty
          ? Text(
        initial,
        style: theme.textTheme.headlineLarge?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w800,
        ),
      )
          : null,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _CenteredProfileState extends StatelessWidget {
  const _CenteredProfileState({
    required this.icon,
    required this.title,
    required this.message,
    this.child,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.68,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 58,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}