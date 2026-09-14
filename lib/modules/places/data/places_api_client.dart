import 'package:dio/dio.dart';
import 'package:explore_dnipro/modules/places/data/mappers/geoapify_place_mapper.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';

import 'dto/geoapify_place_dto.dart';

class PlacesApiClient {
  PlacesApiClient({required this._dio, required this._apiKey});

  static const _placesUrl = 'https://api.geoapify.com/v2/places';

  final Dio _dio;
  final String _apiKey;

  Future<List<Place>> getPlaces({
    required List<String> categories,
    required double minLon,
    required double minLat,
    required double maxLon,
    required double maxLat,
    String language = 'uk',
    int limit = 100,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _placesUrl,
      queryParameters: {
        'categories': categories.join(','),
        'filter':
            'rect:'
            '$minLon,$minLat,'
            '$maxLon,$maxLat',
        'lang': language,
        'limit': limit,
        'apiKey': _apiKey,
      },
    );

    final features = response.data?['features'] as List<dynamic>? ?? const [];

    return features
        .whereType<Map<String, dynamic>>()
        .map(GeoapifyPlaceDto.fromJson)
        .map((dto) => dto.toDomain())
        .whereType<Place>()
        .toList();
  }
}
