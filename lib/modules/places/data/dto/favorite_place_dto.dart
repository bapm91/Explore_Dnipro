class FavoritePlaceDto {
  const FavoritePlaceDto({
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

  factory FavoritePlaceDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final latitude = json['latitude'];
    final longitude = json['longitude'];

    if (id is! String ||
        name is! String ||
        latitude is! num ||
        longitude is! num) {
      throw const FormatException('Invalid favorite place data');
    }

    return FavoritePlaceDto(
      id: id,
      name: name,
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'categories': categories,
      'address': address,
    };
  }
}
