import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';
import 'package:explore_dnipro/modules/places/presentation/place_category_ui.dart';
import 'package:flutter/material.dart';

class PlaceCategorySelector extends StatelessWidget {
  const PlaceCategorySelector({
    required this.selectedCategory,
    required this.onSelected,
    required this.onFavoritesTap,
    required this.enabled,
    super.key,
  });

  final PlaceCategory selectedCategory;
  final ValueChanged<PlaceCategory> onSelected;
  final VoidCallback onFavoritesTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(Icons.favorite_outline, size: 18),
              label: const Text('Обране'),
              onPressed: onFavoritesTap,
            ),
          ),
          ...PlaceCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                avatar: Icon(category.icon, size: 18),
                label: Text(category.label),
                selected: selectedCategory == category,
                showCheckmark: false,
                onSelected: enabled
                    ? (_) => onSelected(category)
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }
}
