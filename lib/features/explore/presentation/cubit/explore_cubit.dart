import 'package:explore_dnipro/modules/places/data/places_api_client.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit({required this._placesApiClient}) : super(const ExploreState());

  final PlacesApiClient _placesApiClient;

  Future<void> loadPlaces({
    required double minLon,
    required double minLat,
    required double maxLon,
    required double maxLat,
    PlaceCategory? category,
  }) async {
    final selectedCategory = category ?? state.selectedCategory;

    final isCategoryChanged = selectedCategory != state.selectedCategory;

    emit(
      state.copyWith(
        status: ExploreStatus.loading,
        selectedCategory: selectedCategory,
        places: isCategoryChanged ? const [] : state.places,
      ),
    );

    try {
      final places = await _placesApiClient.getPlaces(
        categories: [selectedCategory.apiValue],
        minLon: minLon,
        minLat: minLat,
        maxLon: maxLon,
        maxLat: maxLat,
      );

      if (places.isEmpty) {
        emit(state.copyWith(status: ExploreStatus.empty, places: const []));
        return;
      }

      emit(state.copyWith(status: ExploreStatus.success, places: places));
    } catch (_) {
      emit(state.copyWith(status: ExploreStatus.failure));
    }
  }
}
