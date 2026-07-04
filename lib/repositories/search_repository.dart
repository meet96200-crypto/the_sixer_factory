import '../models/match_model.dart';
import '../models/user_model.dart';
import '../services/search_service.dart';

class SearchRepository {
  final SearchService searchService;

  SearchRepository({
    required this.searchService,
  });

  Future<List<UserModel>> searchUsers(String query) {
    return searchService.searchUsers(query);
  }

  Future<List<MatchModel>> searchMatches(
      String query,
      List<MatchModel> matches,
      ) {
    return searchService.searchMatches(query, matches);
  }
}