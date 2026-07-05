class MatchDetailsModel {
  final String id;
  final String name;
  final String status;
  final String venue;
  final String date;
  final String toss;
  final String matchType;
  final String series;

  final String team1;
  final String team2;

  final String team1Logo;
  final String team2Logo;

  final String score;
  final String overs;

  const MatchDetailsModel({
    required this.id,
    required this.name,
    required this.status,
    required this.venue,
    required this.date,
    required this.toss,
    required this.matchType,
    required this.series,
    required this.team1,
    required this.team2,
    required this.team1Logo,
    required this.team2Logo,
    required this.score,
    required this.overs,
  });

  factory MatchDetailsModel.fromJson(Map<String, dynamic> json) {
    String score = "";
    String overs = "";

    if (json["score"] != null &&
        json["score"] is List &&
        json["score"].isNotEmpty) {
      final first = json["score"][0];

      score = "${first["r"] ?? 0}/${first["w"] ?? 0}";
      overs = "${first["o"] ?? ""}";
    }

    String team1 = "";
    String team2 = "";
    String team1Logo = "";
    String team2Logo = "";

    if (json["teamInfo"] != null &&
        json["teamInfo"] is List) {
      final teams = json["teamInfo"];

      if (teams.isNotEmpty) {
        team1 = teams[0]["name"] ?? "";
        team1Logo = teams[0]["img"] ?? "";
      }

      if (teams.length > 1) {
        team2 = teams[1]["name"] ?? "";
        team2Logo = teams[1]["img"] ?? "";
      }
    }

    return MatchDetailsModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      venue: json["venue"] ?? "",
      date: json["date"] ?? "",
      toss: json["tossWinner"] ?? "",
      matchType: json["matchType"] ?? "",
      series: json["series"] ?? json["name"] ?? "",
      team1: team1,
      team2: team2,
      team1Logo: team1Logo,
      team2Logo: team2Logo,
      score: score,
      overs: overs,
    );
  }
}