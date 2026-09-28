import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/repositories/favorites_repository.dart';

class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository(this.saved);

  List<Place> saved;
  int loadCount = 0;

  @override
  Future<List<Place>> loadFavorites() async {
    loadCount++;
    return List.of(saved);
  }

  @override
  Future<void> saveFavorites(List<Place> favorites) async {
    saved = List.of(favorites);
  }
}