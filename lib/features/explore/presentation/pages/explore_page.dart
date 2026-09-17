import 'package:explore_dnipro/features/explore/presentation/widgets/explore_map_overlay.dart';
import 'package:explore_dnipro/features/explore/presentation/widgets/place_category_selector.dart';
import 'package:explore_dnipro/features/explore/presentation/widgets/place_details_sheet.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place.dart';
import 'package:explore_dnipro/modules/places/domain/entities/place_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:explore_dnipro/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:explore_dnipro/features/explore/presentation/cubit/explore_state.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  static const _dniproCenter = LatLng(48.4647, 35.0462);

  final MapController _mapController = MapController();

  bool _hasPendingMapSearch = false;

  void _loadVisiblePlaces() {
    final bounds = _mapController.camera.visibleBounds;

    context.read<ExploreCubit>().loadPlaces(
      minLon: bounds.west,
      minLat: bounds.south,
      maxLon: bounds.east,
      maxLat: bounds.north,
    );
  }

  void _selectCategory(PlaceCategory category) {
    final cubit = context.read<ExploreCubit>();

    if (category == cubit.state.selectedCategory) {
      return;
    }

    final bounds = _mapController.camera.visibleBounds;

    context.read<ExploreCubit>().loadPlaces(
      minLon: bounds.west,
      minLat: bounds.south,
      maxLon: bounds.east,
      maxLat: bounds.north,
      category: category,
    );
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture || _hasPendingMapSearch) {
      return;
    }

    setState(() {
      _hasPendingMapSearch = true;
    });
  }

  void _searchVisibleArea() {
    setState(() {
      _hasPendingMapSearch = false;
    });

    _loadVisiblePlaces();
  }

  void _showPlaceDetails(Place place) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) {
        return PlaceDetailsSheet(place: place);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _dniproCenter,
                  initialZoom: 13,
                  onMapReady: _loadVisiblePlaces,
                  onPositionChanged: _onPositionChanged,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.explore_dnipro',
                  ),
                  MarkerLayer(
                    markers: state.places
                        .map(
                          (place) => Marker(
                            point: LatLng(place.latitude, place.longitude),
                            width: 40,
                            height: 40,
                            child: GestureDetector(
                              onTap: () => _showPlaceDetails(place),
                              child: const Icon(Icons.location_on, size: 40),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors'),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.paddingOf(context).top + 16,
                left: 0,
                right: 0,
                child: PlaceCategorySelector(
                  selectedCategory: state.selectedCategory,
                  enabled: state.status != ExploreStatus.loading,
                  onSelected: _selectCategory,
                ),
              ),
              ExploreMapOverlay(
                status: state.status,
                hasPlaces: state.places.isNotEmpty,
                hasPendingMapSearch: _hasPendingMapSearch,
                onSearchArea: _searchVisibleArea,
                onRetry: _loadVisiblePlaces,
              ),
            ],
          );
        },
      ),
    );
  }
}
