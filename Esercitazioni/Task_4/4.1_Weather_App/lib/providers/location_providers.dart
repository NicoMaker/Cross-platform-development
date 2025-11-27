import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import 'weather_providers.dart';

final currentPositionProvider = FutureProvider<Position>((ref) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw Exception('Servizi di localizzazione disabilitati');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('Permesso posizione negato');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw Exception('Permesso posizione negato permanentemente');
  }

  return Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
});

final weatherForCurrentLocationProvider =
    FutureProvider<Weather>((ref) async {
  final pos = await ref.watch(currentPositionProvider.future);
  final api = ref.watch(weatherApiServiceProvider);
  return api.fetchByLocation(pos.latitude, pos.longitude);
});
