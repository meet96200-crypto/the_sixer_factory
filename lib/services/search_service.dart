import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/match_model.dart';
import '../models/user_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Search Users
  Future<List<UserModel>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];

    final snapshot = await _firestore
        .collection('users')
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromMap(doc.data()))
        .toList();
  }

  /// Search Matches (temporary local search)
  Future<List<MatchModel>> searchMatches(
      String query,
      List<MatchModel> matches,
      ) async {
    if (query.trim().isEmpty) return [];

    final lower = query.toLowerCase();

    return matches.where((match) {
      return match.team1.toLowerCase().contains(lower) ||
          match.team2.toLowerCase().contains(lower) ||
          match.name.toLowerCase().contains(lower) ||
          match.series.toLowerCase().contains(lower);
    }).toList();
  }
}