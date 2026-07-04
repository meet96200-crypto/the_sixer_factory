import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _imagePicker = ImagePicker();

  bool _isLoadingProfile = true;
  bool _isSaving = false;
  bool _isPickingImage = false;
  String? _country;
  String? _favoriteTeam;
  String? _favoritePlayer;
  UserModel? _loadedUser;

  static const List<String> _countries = [
    'India',
    'Australia',
    'England',
    'New Zealand',
    'South Africa',
    'Sri Lanka',
    'Bangladesh',
    'Afghanistan',
    'Pakistan',
  ];

  static const List<String> _teams = [
    'India',
    'Australia',
    'England',
    'New Zealand',
    'South Africa',
    'Sri Lanka',
    'Bangladesh',
    'Afghanistan',
    'Pakistan',
  ];

  static const List<String> _players = [
    'Virat Kohli',
    'Rohit Sharma',
    'Shubman Gill',
    'Jasprit Bumrah',
    'KL Rahul',
    'Hardik Pandya',
    'Rishabh Pant',
    'MS Dhoni',
    'AB de Villiers',
    'Steve Smith',
    'Kane Williamson',
    'Joe Root',
    'Babar Azam',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      if (!mounted) return;
      setState(() => _isLoadingProfile = false);
      _showMessage('Please sign in to edit your profile.');
      return;
    }

    setState(() => _isLoadingProfile = true);

    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadProfile(firebaseUser.uid);

    if (!mounted) return;

    final profile = profileProvider.user;
    _loadedUser = profile;
    _nameController.text = profile?.name.trim().isNotEmpty == true
        ? profile!.name
        : firebaseUser.displayName ?? '';
    _bioController.text = profile?.bio ?? '';
    _country = _valueFromOptions(profile?.country, _countries);
    _favoriteTeam = _valueFromOptions(profile?.favoriteTeam, _teams);
    _favoritePlayer = _valueFromOptions(profile?.favoritePlayer, _players);

    setState(() => _isLoadingProfile = false);

    if (profileProvider.error.isNotEmpty) {
      _showMessage(profileProvider.error);
    }
  }

  Future<void> _pickAndUploadProfilePhoto() async {
    if (_isPickingImage || context.read<ProfileProvider>().isUploadingPhoto) {
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _showMessage('Please sign in to upload your profile photo.');
      return;
    }

    setState(() => _isPickingImage = true);

    try {
      final pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (pickedImage == null) return;

      final imageBytes = await pickedImage.readAsBytes();
      final profileProvider = context.read<ProfileProvider>();
      final photoUrl = await profileProvider.uploadProfilePhoto(
        uid: firebaseUser.uid,
        imageBytes: imageBytes,
      );

      if (!mounted) return;

      if (photoUrl == null || profileProvider.error.isNotEmpty) {
        _showMessage(
          profileProvider.error.isNotEmpty
              ? profileProvider.error
              : 'Could not upload profile photo.',
        );
        return;
      }

      setState(() {
        _loadedUser = profileProvider.user ??
            _loadedUser?.copyWith(
              photoUrl: photoUrl,
              updatedAt: DateTime.now(),
            );
      });
      _showMessage('Profile photo updated.');
    } catch (e) {
      if (mounted) {
        _showMessage(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final profileProvider = context.read<ProfileProvider>();
    if (profileProvider.isUploadingPhoto) {
      _showMessage('Please wait for the photo upload to finish.');
      return;
    }

    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) {
      _showMessage('Please sign in to save your profile.');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSaving = true);

    final now = DateTime.now();
    final providerUser = profileProvider.user;
    final existing = providerUser ?? _loadedUser;
    final updatedUser = UserModel(
      uid: firebaseUser.uid,
      name: _nameController.text.trim(),
      email: existing?.email.trim().isNotEmpty == true
          ? existing!.email
          : firebaseUser.email ?? '',
      photoUrl: existing?.photoUrl ?? firebaseUser.photoURL ?? '',
      bio: _bioController.text.trim(),
      country: _country!,
      favoriteTeam: _favoriteTeam!,
      favoritePlayer: _favoritePlayer!,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    await profileProvider.updateProfile(updatedUser);

    if (!mounted) return;

    setState(() {
      _loadedUser = updatedUser;
      _isSaving = false;
    });

    if (profileProvider.error.isNotEmpty) {
      _showMessage(profileProvider.error);
      return;
    }

    _showMessage('Profile updated successfully.');
    Navigator.of(context).pop(updatedUser);
  }

  String? _valueFromOptions(String? value, List<String> options) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return options.contains(trimmed) ? trimmed : null;
  }

  String? _requiredText(String? value, String fieldName) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return '$fieldName is required';
    if (trimmed.length < 3) return '$fieldName must be at least 3 characters';
    return null;
  }

  String? _requiredSelection(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Select your $fieldName';
    }
    return null;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final profileProvider = context.watch<ProfileProvider>();
    final email = firebaseUser?.email ?? _loadedUser?.email ?? '';
    final isUploadingPhoto = profileProvider.isUploadingPhoto;
    final isBusy = _isLoadingProfile || _isSaving || isUploadingPhoto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: _EditableProfileAvatar(
                  imageProvider: _avatarImage(firebaseUser),
                  isUploading: isUploadingPhoto,
                  progress: profileProvider.photoUploadProgress,
                  onTap: isBusy ? null : _pickAndUploadProfilePhoto,
                ),
              ),
              if (isUploadingPhoto) ...[
                const SizedBox(height: 14),
                LinearProgressIndicator(
                  value: profileProvider.photoUploadProgress > 0
                      ? profileProvider.photoUploadProgress
                      : null,
                ),
                const SizedBox(height: 8),
                Text(
                  'Uploading photo ${(profileProvider.photoUploadProgress * 100).clamp(0, 100).round()}%',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 14),
              if (email.isNotEmpty)
                Center(
                  child: Text(
                    email,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                enabled: !isBusy,
                decoration: _fieldDecoration(
                  label: 'Full Name',
                  icon: Icons.person_outline,
                ),
                validator: (value) => _requiredText(value, 'Full Name'),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _bioController,
                textInputAction: TextInputAction.newline,
                textCapitalization: TextCapitalization.sentences,
                enabled: !isBusy,
                maxLines: 4,
                maxLength: 160,
                decoration: _fieldDecoration(
                  label: 'Bio',
                  icon: Icons.edit_note,
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.isEmpty) return 'Bio is required';
                  if (trimmed.length < 10) {
                    return 'Bio must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                initialValue: _country,
                isExpanded: true,
                decoration: _fieldDecoration(
                  label: 'Country',
                  icon: Icons.public,
                ),
                items: _countries
                    .map(
                      (country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  ),
                )
                    .toList(),
                onChanged: isBusy
                    ? null
                    : (value) => setState(() => _country = value),
                validator: (value) =>
                    _requiredSelection(value, 'country'),
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                initialValue: _favoriteTeam,
                isExpanded: true,
                decoration: _fieldDecoration(
                  label: 'Favorite Team',
                  icon: Icons.favorite_outline,
                ),
                items: _teams
                    .map(
                      (team) => DropdownMenuItem<String>(
                    value: team,
                    child: Text(team),
                  ),
                )
                    .toList(),
                onChanged: isBusy
                    ? null
                    : (value) => setState(() => _favoriteTeam = value),
                validator: (value) =>
                    _requiredSelection(value, 'favorite team'),
              ),
              const SizedBox(height: 18),
              DropdownButtonFormField<String>(
                initialValue: _favoritePlayer,
                isExpanded: true,
                decoration: _fieldDecoration(
                  label: 'Favorite Player',
                  icon: Icons.star_outline,
                ),
                items: _players
                    .map(
                      (player) => DropdownMenuItem<String>(
                    value: player,
                    child: Text(player),
                  ),
                )
                    .toList(),
                onChanged: isBusy
                    ? null
                    : (value) =>
                    setState(() => _favoritePlayer = value),
                validator: (value) =>
                    _requiredSelection(value, 'favorite player'),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: isBusy ? null : _saveProfile,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.save_outlined),
                  label: Text(_isSaving ? 'Saving...' : 'Save Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _avatarImage(User? user) {
    final photoUrl = _loadedUser?.photoUrl.trim().isNotEmpty == true
        ? _loadedUser!.photoUrl
        : user?.photoURL;

    if (photoUrl == null || photoUrl.trim().isEmpty) return null;
    return NetworkImage(photoUrl);
  }
}

class _EditableProfileAvatar extends StatelessWidget {
  const _EditableProfileAvatar({
    required this.imageProvider,
    required this.isUploading,
    required this.progress,
    required this.onTap,
  });

  final ImageProvider? imageProvider;
  final bool isUploading;
  final double progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Upload profile photo',
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? const Icon(Icons.person, size: 52)
                  : null,
            ),
            if (isUploading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.44),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: CircularProgressIndicator(
                        value: progress > 0 ? progress : null,
                        strokeWidth: 3,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: -2,
              bottom: 0,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.scaffoldBackgroundColor,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: theme.colorScheme.onPrimary,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
