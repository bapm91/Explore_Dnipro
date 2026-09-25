import 'dart:convert';

import 'package:explore_dnipro/modules/places/data/dto/favorite_place_dto.dart';
import 'package:explore_dnipro/modules/places/data/mappers/favorite_place_mapper.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/repositories/favorites_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFavoritesRepository implements FavoritesRepository {
  SharedPreferencesFavoritesRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _favoritesKey = 'favorite_places_v1';

  final SharedPreferencesAsync _preferences;

  @override
  Future<List<Place>> loadFavorites() async {
    final storedFavorites =
        await _preferences.getStringList(_favoritesKey) ?? const [];

    final favorites = <Place>[];

    for (final storedFavorite in storedFavorites) {
      try {
        final json = jsonDecode(storedFavorite);

        if (json is! Map<String, dynamic>) {
          continue;
        }

        final dto = FavoritePlaceDto.fromJson(json);

        favorites.add(dto.toDomain());
      } on FormatException {
        // Ignore an invalid stored item.
      } on TypeError {
        // Ignore an item with unexpected field types.
      }
    }

    return List.unmodifiable(favorites);
  }

  @override
  Future<void> saveFavorites(List<Place> favorites) async {
    final uniqueFavorites = {for (final place in favorites) place.id: place};

    final storedFavorites = uniqueFavorites.values
        .map((place) => place.toFavoriteDto())
        .map((dto) => dto.toJson())
        .map(jsonEncode)
        .toList();

    await _preferences.setStringList(_favoritesKey, storedFavorites);
  }
}
