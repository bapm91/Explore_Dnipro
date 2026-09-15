import 'package:explore_dnipro/features/explore/presentation/cubit/explore_cubit.dart';
import 'package:explore_dnipro/features/explore/presentation/pages/explore_page.dart';
import 'package:explore_dnipro/modules/places/data/places_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key, required this.placesApiClient});

  final PlacesApiClient placesApiClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Explore Dnipro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: BlocProvider(
        create: (_) => ExploreCubit(placesApiClient: placesApiClient),
        child: const ExplorePage(),
      ),
    );
  }
}
