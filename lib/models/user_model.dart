class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String bio;
  final String country;
  final String favoriteTeam;
  final String favoritePlayer;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.bio,
    required this.country,
    required this.favoriteTeam,
    required this.favoritePlayer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value == null) return DateTime.now();

      if (value is DateTime) return value;

      if (value.toString().contains("Timestamp")) {
        try {
          return value.toDate();
        } catch (_) {}
      }

      return DateTime.tryParse(value.toString()) ?? DateTime.now();
    }

    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      country: map['country'] ?? '',
      favoriteTeam: map['favoriteTeam'] ?? '',
      favoritePlayer: map['favoritePlayer'] ?? '',
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'country': country,
      'favoriteTeam': favoriteTeam,
      'favoritePlayer': favoritePlayer,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? bio,
    String? country,
    String? favoriteTeam,
    String? favoritePlayer,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      favoriteTeam: favoriteTeam ?? this.favoriteTeam,
      favoritePlayer: favoritePlayer ?? this.favoritePlayer,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}