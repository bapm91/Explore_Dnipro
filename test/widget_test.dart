import 'package:explore_dnipro/features/explore/presentation/widgets/place_details_sheet.dart';
import 'package:explore_dnipro/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'modules/places/repositories/fake_favorite_repository.dart';

void main() {
  testWidgets('adds a place to favorites', (tester) async {
    const place = Place(
      id: 'museum-1',
      name: 'Історичний музей',
      latitude: 48.46,
      longitude: 35.05,
      categories: ['entertainment.museum'],
      address: 'Дніпро',
    );

    final repository = FakeFavoritesRepository([]);
    final cubit = FavoritesCubit(repository: repository);
    addTearDown(cubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: cubit,
        child: MaterialApp(
          home: Scaffold(body: PlaceDetailsSheet(place: place)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(repository.saved, [place]);
  });
}
