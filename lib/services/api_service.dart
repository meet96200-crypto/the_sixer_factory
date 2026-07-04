import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/match_model.dart';

class ApiService {
  static const String apiKey = "e952b0ca-53c7-4a38-b9e7-981208459228";
  static const String baseUrl = "https://api.cricapi.com/v1";

  Future<List<MatchModel>> getLiveMatches() async {
    try {
      final url = Uri.parse(
        "$baseUrl/currentMatches?apikey=$apiKey&offset=0",
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      print(response.body);
      if (response.statusCode != 200) {
        throw Exception("Failed to load live matches");
      }

      final json = jsonDecode(response.body);

      if (json["status"] == "failure") {
        throw Exception(json["reason"]);
      }

      if (json["data"] == null) {
        return [];
      }

      final List matches = json["data"];

      return matches
          .map((e) => MatchModel.fromJson(e))
          .where((match) =>
      match.liveScore.isNotEmpty &&
          match.status.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception("Unable to load live matches.\n$e");
    }
  }

  Future<List<MatchModel>> getUpcomingMatches() async {
    try {
      final url = Uri.parse(
        "$baseUrl/matches?apikey=$apiKey&offset=0",
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );


      if (response.statusCode != 200) {
        throw Exception("Failed to load upcoming matches");
      }

      final json = jsonDecode(response.body);

      if (json["status"] == "failure") {
        throw Exception(json["reason"]);
      }

      if (json["data"] == null) {
        return [];
      }
      final List matches = json["data"];

      return matches
          .map((e) => MatchModel.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Unable to load upcoming matches.\n$e");
    }
  }
}