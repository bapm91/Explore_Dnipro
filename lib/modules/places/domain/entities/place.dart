import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.categories,
    this.address,
  });

  final String id;
  final String name;
  final double lat;
  final double lon;
  final List<String> categories;
  final String? address;

  @override
  List<Object?> get props => [
        id,
        name,
        lat,
        lon,
        categories,
        address,
      ];
}