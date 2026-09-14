import 'package:explore_dnipro/modules/places/data/places_api_client.dart';
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
  }) async {
    emit(state.copyWith(status: ExploreStatus.loading));

    try {
      final places = await _placesApiClient.getPlaces(
        categories: const ['catering.restaurant'],
        minLon: minLon,
        minLat: minLat,
        maxLon: maxLon,
        maxLat: maxLat,
      );

      emit(ExploreState(status: ExploreStatus.success, places: places));
    } catch (_) {
      emit(state.copyWith(status: ExploreStatus.failure));
    }
  }
}
