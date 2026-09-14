import '../../domain/entities/place.dart';
import '../dto/geoapify_place_dto.dart';

extension GeoapifyPlaceMapper on GeoapifyPlaceDto {
  Place? toDomain() {
    final id = this.id;
    final name = this.name;
    final lat = this.lat;
    final lon = this.lon;

    if (id == null ||
        name == null ||
        lat == null ||
        lon == null) {
      return null;
    }

    return Place(
      id: id,
      name: name,
      latitude: lat,
      longitude: lon,
      categories: categories,
      address: address,
    );
  }
}