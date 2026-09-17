class GeoapifyPlaceDto {
  const GeoapifyPlaceDto({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
    required this.categories,
    required this.address,
  });

  final String? id;
  final String? name;
  final double? lat;
  final double? lon;
  final List<String> categories;
  final String? address;

  factory GeoapifyPlaceDto.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>? ?? const {};

    final rawName = properties['name'];

    final geometry = json['geometry'] as Map<String, dynamic>? ?? const {};

    final coordinates = geometry['coordinates'] as List<dynamic>?;

    return GeoapifyPlaceDto(
      id: properties['place_id'] as String?,
      name: rawName is String && rawName.trim().isNotEmpty
          ? rawName.trim()
          : null,
      lon: (coordinates?.elementAtOrNull(0) as num?)?.toDouble(),
      lat: (coordinates?.elementAtOrNull(1) as num?)?.toDouble(),
      categories: (properties['categories'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      address: properties['formatted'] as String?,
    );
  }
}
