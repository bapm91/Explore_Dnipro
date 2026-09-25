import 'package:explore_dnipro/features/explore/presentation/widgets/place_details_sheet.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows place details', (tester) async {
    const place = Place(
      id: 'museum-1',
      name: 'Історичний музей',
      latitude: 48.46,
      longitude: 35.05,
      categories: ['entertainment.museum'],
      address: 'Дніпро',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: PlaceDetailsSheet(place: place)),
      ),
    );

    expect(find.text('Історичний музей'), findsOneWidget);
    expect(find.text('Дніпро'), findsOneWidget);
  });
}
