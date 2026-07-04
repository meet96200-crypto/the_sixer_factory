import '../services/favorite_service.dart';

class FavoriteRepository {
  final FavoriteService favoriteService;

  FavoriteRepository({
    required this.favoriteService,
  });

  Future<void> addFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) {
    return favoriteService.addFavorite(
      uid: uid,
      type: type,
      itemId: itemId,
    );
  }

  Future<void> removeFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) {
    return favoriteService.removeFavorite(
      uid: uid,
      type: type,
      itemId: itemId,
    );
  }

  Future<bool> isFavorite({
    required String uid,
    required String type,
    required String itemId,
  }) {
    return favoriteService.isFavorite(
      uid: uid,
      type: type,
      itemId: itemId,
    );
  }

  Stream<List<String>> getFavorites({
    required String uid,
    required String type,
  }) {
    return favoriteService.getFavorites(
      uid: uid,
      type: type,
    );
  }
}