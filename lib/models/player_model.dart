class PlayerModel {
  final String id;
  final String name;
  final String country;
  final String role;
  final String battingStyle;
  final String bowlingStyle;
  final String image;

  const PlayerModel({
    required this.id,
    required this.name,
    required this.country,
    required this.role,
    required this.battingStyle,
    required this.bowlingStyle,
    required this.image,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json["id"]?.toString() ?? "",
      name: json["name"] ?? "",
      country: json["country"] ?? "",
      role: json["role"] ?? "",
      battingStyle: json["battingStyle"] ?? "",
      bowlingStyle: json["bowlingStyle"] ?? "",
      image: json["playerImg"] ?? "",
    );
  }
}