import 'package:explore_dnipro/modules/places/data/dto/favorite_place_dto.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';

extension FavoritePlaceDtoMapper on FavoritePlaceDto {
  Place toDomain() {
    return Place(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      categories: categories,
      address: address,
    );
  }
}

extension PlaceFavoriteMapper on Place {
  FavoritePlaceDto toFavoriteDto() {
    return FavoritePlaceDto(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      categories: categories,
      address: address,
    );
  }
}
