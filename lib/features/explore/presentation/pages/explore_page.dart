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
  static const _dniproCenter = LatLng(
    48.4647,
    35.0462,
  );

  final MapController _mapController = MapController();

  void _loadVisiblePlaces() {
    final bounds = _mapController.camera.visibleBounds;

    context.read<ExploreCubit>().loadPlaces(
      minLon: bounds.west,
      minLat: bounds.south,
      maxLon: bounds.east,
      maxLat: bounds.north,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ExploreCubit, ExploreState>(
        builder: (context, state) {
          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _dniproCenter,
              initialZoom: 13,
              onMapReady: _loadVisiblePlaces,
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
                        point: LatLng(
                          place.latitude,
                          place.longitude,
                        ),
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          size: 40,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          );
        },
      ),
    );
  }
}