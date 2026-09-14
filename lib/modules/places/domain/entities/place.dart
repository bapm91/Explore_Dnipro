import 'package:equatable/equatable.dart';

class Place extends Equatable {
  const Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.categories,
    this.address,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> categories;
  final String? address;

  @override
  List<Object?> get props => [
        id,
        name,
        latitude,
        longitude,
        categories,
        address,
      ];
}