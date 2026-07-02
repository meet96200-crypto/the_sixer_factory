class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String favoriteTeam;
  final String favoritePlayer;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.favoriteTeam,
    required this.favoritePlayer,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      favoriteTeam: map['favoriteTeam'] ?? '',
      favoritePlayer: map['favoritePlayer'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'favoriteTeam': favoriteTeam,
      'favoritePlayer': favoritePlayer,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}