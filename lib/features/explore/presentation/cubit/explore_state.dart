import 'package:equatable/equatable.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';

enum ExploreStatus {
  initial,
  loading,
  success,
  empty,
  failure,
}

class ExploreState extends Equatable {
  const ExploreState({
    this.status = ExploreStatus.initial,
    this.places = const [],
  });

  final ExploreStatus status;
  final List<Place> places;

  ExploreState copyWith({
    ExploreStatus? status,
    List<Place>? places,
  }) {
    return ExploreState(
      status: status ?? this.status,
      places: places ?? this.places,
    );
  }

  @override
  List<Object?> get props => [
        status,
        places,
      ];
}