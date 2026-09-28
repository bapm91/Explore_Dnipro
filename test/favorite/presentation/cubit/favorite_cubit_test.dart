import 'package:explore_dnipro/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../modules/places/repositories/fake_favorite_repository.dart';

void main() {
  test('toggles favorites without reloading storage', () async {
    const place = Place(
      id: 'museum-1',
      name: 'Історичний музей',
      latitude: 48.46,
      longitude: 35.05,
      categories: ['entertainment.museum'],
      address: 'Дніпро',
    );
    const park = Place(
      id: 'park-1',
      name: 'Міський парк',
      latitude: 48.47,
      longitude: 35.06,
      categories: ['leisure.park'],
      address: 'Дніпро',
    );

    const theater = Place(
      id: 'theater-1',
      name: 'Міський театр',
      latitude: 48.45,
      longitude: 35.04,
      categories: ['entertainment.theatre'],
      address: 'Дніпро',
    );

    final repository = FakeFavoritesRepository([place]);
    final cubit = FavoritesCubit(repository: repository);

    addTearDown(cubit.close);

    await cubit.toggleFavorite(place);
    expect(cubit.isFavorite(place.id), isFalse);
    expect(repository.saved, isEmpty);

    await cubit.toggleFavorite(place);
    expect(cubit.isFavorite(place.id), isTrue);
    expect(repository.saved, [place]);

    await cubit.toggleFavorite(park);
    expect(cubit.isFavorite(park.id), isTrue);
    expect(repository.saved, [place, park]);

    await cubit.toggleFavorite(theater);
    expect(cubit.isFavorite(theater.id), isTrue);
    expect(repository.saved, [place, park, theater]);

    await cubit.toggleFavorite(place);
    expect(cubit.isFavorite(place.id), isFalse);
    expect(repository.loadCount, 1);
    expect(repository.saved, [park, theater]);
  });
}
