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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          final isLoading = state.status == ExploreStatus.loading;

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _dniproCenter,
                  initialZoom: 13,
                  onMapReady: _loadVisiblePlaces,
                  onPositionChanged: _onPositionChanged,
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
                            child: const Icon(Icons.location_on, size: 40),
                          ),
                        )
                        .toList(),
                  ),
                  const SimpleAttributionWidget(
                    source: Text('OpenStreetMap contributors'),
                  ),
                ],
              ),
              if (state.status == ExploreStatus.failure &&
                  !_hasPendingMapSearch)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('Не вдалося завантажити місця'),
                          ),
                          TextButton(
                            onPressed: _loadVisiblePlaces,
                            child: const Text('Спробувати ще раз'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (state.status == ExploreStatus.empty && !_hasPendingMapSearch)
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Text(
                        'У цій області нічого не знайдено',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              if (_hasPendingMapSearch)
                Positioned(
                  bottom: MediaQuery.paddingOf(context).top + 16,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: FilledButton.icon(
                      onPressed: isLoading ? null : _searchVisibleArea,
                      icon: isLoading
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.search),
                      label: const Text('Шукати в цій області'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
