import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';
import 'package:flutter/material.dart';

class PlaceCategorySelector extends StatelessWidget {
  const PlaceCategorySelector({
    required this.selectedCategory,
    required this.onSelected,
    required this.enabled,
    super.key,
  });

  final PlaceCategory selectedCategory;
  final ValueChanged<PlaceCategory> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: PlaceCategory.values.map((category) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_categoryLabel(category)),
              selected: selectedCategory == category,
              onSelected: enabled
                  ? (_) => onSelected(category)
                  : null,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _categoryLabel(PlaceCategory category) {
    return switch (category) {
      PlaceCategory.restaurants => 'Ресторани',
      PlaceCategory.cafes => 'Кафе',
      PlaceCategory.museums => 'Музеї',
      PlaceCategory.attractions => 'Пам’ятки',
    };
  }
}