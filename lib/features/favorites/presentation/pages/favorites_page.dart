import 'package:explore_dnipro/features/explore/presentation/widgets/place_details_sheet.dart';
import 'package:explore_dnipro/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:explore_dnipro/features/favorites/presentation/widgets/favorite_place_card.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  void _showPlaceDetails(BuildContext context, Place place) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => PlaceDetailsSheet(place: place),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Обране')),
      body: BlocBuilder<FavoritesCubit, List<Place>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_border, size: 56),
                    SizedBox(height: 16),
                    Text(
                      'Поки немає обраних місць',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Додайте місце через сердечко на карті.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final place = favorites[index];

              return FavoritePlaceCard(
                key: ValueKey(place.id),
                place: place,
                onTap: () => _showPlaceDetails(context, place),
                onRemove: () => context.read<FavoritesCubit>().toggleFavorite(
                  place,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
