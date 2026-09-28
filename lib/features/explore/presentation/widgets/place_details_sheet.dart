import 'package:explore_dnipro/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceDetailsSheet extends StatelessWidget {
  const PlaceDetailsSheet({required this.place, super.key});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    place.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                BlocBuilder<FavoritesCubit, List<Place>>(
                  builder: (context, state) {
                    return IconButton(
                      onPressed: () {
                        BlocProvider.of<FavoritesCubit>(
                          context,
                        ).toggleFavorite(place);
                      },
                      icon: Icon(
                        state.contains(place)
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    );
                  },
                ),
              ],
            ),
            if (place.address != null) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(place.address!)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
