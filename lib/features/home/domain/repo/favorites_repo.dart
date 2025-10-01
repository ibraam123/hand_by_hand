abstract class FavoritesRepository {
  Future<List<String>> getFavorites();
  Future<bool> isFavorite(String id);
  Future<void> addFavorite(String id);
  Future<void> removeFavorite(String id);
  Future<void> clearAll();
}