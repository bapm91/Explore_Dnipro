import 'package:equatable/equatable.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';

enum ExploreStatus { initial, loading, success, empty, failure }

class ExploreState extends Equatable {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.places = const [],
    this.selectedCategory = PlaceCategory.restaurants,
  });

  final PlaceCategory selectedCategory;
  final ExploreStatus status;
  final List<Place> places;

  ExploreState copyWith({
    ExploreStatus? status,
    List<Place>? places,
    PlaceCategory? selectedCategory,
  }) {
    return ExploreState(
      status: status ?? this.status,
      places: places ?? this.places,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [status, places, selectedCategory];
}
