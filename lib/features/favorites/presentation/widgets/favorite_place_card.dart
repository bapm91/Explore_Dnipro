import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/presentation/place_category_ui.dart';
import 'package:flutter/material.dart';

class FavoritePlaceCard extends StatelessWidget {
  const FavoritePlaceCard({
    required this.place,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Place place;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final category = categoryForPlace(place);
    final colorScheme = Theme.of(context).colorScheme;
    final address = place.address?.trim();
    final details = [
      category?.label ?? 'Інше',
      if (address != null && address.isNotEmpty) address,
    ].join(' • ');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: Icon(category?.icon ?? Icons.place_outlined),
        ),
        title: Text(
          place.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          details,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          tooltip: 'Вилучити з обраного',
          onPressed: onRemove,
          icon: const Icon(Icons.favorite),
        ),
        onTap: onTap,
      ),
    );
  }
}
