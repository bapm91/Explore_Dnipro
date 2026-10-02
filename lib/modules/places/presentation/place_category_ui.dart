import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';
import 'package:flutter/material.dart';

extension PlaceCategoryUi on PlaceCategory {
  String get label => switch (this) {
    PlaceCategory.restaurants => 'Ресторани',
    PlaceCategory.cafes => 'Кафе',
    PlaceCategory.museums => 'Музеї',
    PlaceCategory.attractions => 'Пам’ятки',
  };

  IconData get icon => switch (this) {
    PlaceCategory.restaurants => Icons.restaurant_outlined,
    PlaceCategory.cafes => Icons.local_cafe_outlined,
    PlaceCategory.museums => Icons.museum_outlined,
    PlaceCategory.attractions => Icons.account_balance_outlined,
  };
}

PlaceCategory? categoryForPlace(Place place) {
  for (final category in PlaceCategory.values) {
    if (place.categories.any(
      (value) =>
          value == category.apiValue ||
          value.startsWith('${category.apiValue}.'),
    )) {
      return category;
    }
  }

  return null;
}
