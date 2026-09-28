import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/repositories/favorites_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesCubit extends Cubit<List<Place>> {
  FavoritesCubit({required this._repository}) : super(const []) {
    _initialLoad = loadFavorites();
  }

  late final Future<void> _initialLoad;
  final FavoritesRepository _repository;

  Future<void> loadFavorites() async {
    final favorites = await _repository.loadFavorites();

    emit(favorites);
  }

  Future<void> toggleFavorite(Place place) async {
    await _initialLoad;

    final alreadyFavorite = isFavorite(place.id);
    final updated = alreadyFavorite
        ? state.where((item) => item.id != place.id).toList()
        : [...state, place];

    await _repository.saveFavorites(updated);
    emit(updated);
  }

  bool isFavorite(String id) => state.any((place) => place.id == id);
}
