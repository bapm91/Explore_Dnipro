import 'package:explore_dnipro/modules/places/data/repositories/shared_preferences_favorites_repository.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = null;
  });

  test('skips invalid JSON', () async {
    final preferences = SharedPreferencesAsync();
    await preferences.setStringList('favorite_places_v1', ['{broken json']);

    final repository = SharedPreferencesFavoritesRepository(
      preferences: preferences,
    );

    final favorites = await repository.loadFavorites();

    expect(favorites, isEmpty);
  });

  test('loads no favorites', () async {
    final repository = SharedPreferencesFavoritesRepository(
      preferences: SharedPreferencesAsync(),
    );
    final loaded = await repository.loadFavorites();

    expect(loaded, const <Place>[]);
  });

  test('loads a saved favorite', () async {
    final repository = SharedPreferencesFavoritesRepository(
      preferences: SharedPreferencesAsync(),
    );
    const place = Place(
      id: 'museum-1',
      name: 'Історичний музей',
      latitude: 48.46,
      longitude: 35.05,
      categories: ['entertainment.museum'],
      address: 'Дніпро',
    );

    await repository.saveFavorites([place]);
    final loaded = await repository.loadFavorites();

    expect(loaded, [place]);
  });
}
