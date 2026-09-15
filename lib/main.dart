import 'package:dio/dio.dart';
import 'package:explore_dnipro/modules/places/data/places_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  final apiKey = dotenv.env['GEOAPIFY_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    throw StateError('GEOAPIFY_API_KEY is missing');
  }

  final placesApiClient = PlacesApiClient(dio: Dio(), apiKey: apiKey);

  runApp(App(placesApiClient: placesApiClient));
}
