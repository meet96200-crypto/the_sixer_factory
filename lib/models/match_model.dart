import 'package:intl/intl.dart';

class MatchModel {
  final String id;
  final String name;
  final String status;
  final String venue;
  final String date;

  final String team1;
  final String team2;

  final String team1Logo;
  final String team2Logo;

  final String liveScore;
  final String overs;

  final String matchType;
  final String series;

  final bool matchStarted;
  final bool matchEnded;

  MatchModel({
    required this.id,
    required this.name,
    required this.status,
    required this.venue,
    required this.date,
    required this.team1,
    required this.team2,
    required this.team1Logo,
    required this.team2Logo,
    required this.liveScore,
    required this.overs,
    required this.matchType,
    required this.series,
    required this.matchStarted,
    required this.matchEnded,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
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

    if (json["teams"] != null && json["teams"] is List) {
      if (json["teams"].isNotEmpty) {
        team1 = json["teams"][0];
      }

      if (json["teams"].length > 1) {
        team2 = json["teams"][1];
      }
    }

    if (json["teamInfo"] != null &&
        json["teamInfo"] is List) {
      final info = json["teamInfo"];

      if (info.isNotEmpty) {
        team1Logo = info[0]["img"] ?? "";
      }

      if (info.length > 1) {
        team2Logo = info[1]["img"] ?? "";
      }
    }

    return MatchModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      status: json["status"] ?? "",
      venue: json["venue"] ?? "",
      date: json["date"] ?? "",
      team1: team1,
      team2: team2,
      team1Logo: team1Logo,
      team2Logo: team2Logo,
      liveScore: score,
      overs: overs,
      matchType: json["matchType"] ?? "",
      series: json["name"] ?? "",
      matchStarted: json["matchStarted"] ?? false,
      matchEnded: json["matchEnded"] ?? false,
    );
  }

  // ---------------- Helpers ----------------

  bool get isLive => matchStarted && !matchEnded;

  bool get isUpcoming => !matchStarted;

  bool get isFinished => matchEnded;

  String get displayVenue {
    if (venue.trim().isEmpty ||
        venue.toLowerCase() == "tbc, tbc") {
      return "Venue To Be Announced";
    }
    return venue;
  }

  String get displayScore {
    if (liveScore.trim().isEmpty) {
      return "Score Unavailable";
    }
    return liveScore;
  }

  String get displayOvers {
    if (overs.trim().isEmpty) {
      return "--";
    }
    return overs;
  }

  String get displayStatus {
    if (isLive) return "LIVE";
    if (isFinished) return status;
    return "Upcoming";
  }

  String get shortTitle {
    if (team1.isNotEmpty && team2.isNotEmpty) {
      return "$team1 vs $team2";
    }
    return name;
  }

  String get formattedDate {
    if (date.isEmpty) return "";

    try {
      final parsed = DateTime.parse(date);
      return DateFormat("dd MMM yyyy").format(parsed);
    } catch (_) {
      return date;
    }
  }
}