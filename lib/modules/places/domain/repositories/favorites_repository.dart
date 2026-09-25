import 'package:explore_dnipro/modules/places/domain/entities/place.dart';

abstract interface class FavoritesRepository {
  Future<List<Place>> loadFavorites();

  Future<void> saveFavorites(List<Place> favorites);
}
