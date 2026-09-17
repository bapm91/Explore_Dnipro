enum PlaceCategory {
  restaurants('catering.restaurant'),
  cafes('catering.cafe'),
  museums('entertainment.museum'),
  attractions('tourism.attraction');

  const PlaceCategory(this.apiValue);

  final String apiValue;
}