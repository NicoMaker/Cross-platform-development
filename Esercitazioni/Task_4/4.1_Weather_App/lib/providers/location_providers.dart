import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';
import 'weather_providers.dart';

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}

// Provider per ottenere la posizione corrente
final currentPositionProvider = FutureProvider<Position>((ref) async {
  // Verifica se il servizio di localizzazione è attivo
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw LocationException(
      'Servizi di localizzazione disabilitati. Attivali nelle impostazioni.',
    );
  }

  // Verifica i permessi
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw LocationException('Permesso di localizzazione negato.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    throw LocationException(
      'Permesso negato permanentemente. Modificalo nelle impostazioni dell\'app.',
    );
  }

  // Ottiene la posizione
  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
  } catch (e) {
    throw LocationException('Impossibile ottenere la posizione: ${e.toString()}');
  }
});

// Provider per il meteo basato sulla posizione corrente
final weatherForCurrentLocationProvider = FutureProvider<Weather>((ref) async {
  final position = await ref.watch(currentPositionProvider.future);
  final api = ref.watch(weatherApiServiceProvider);

  return api.fetchByLocation(position.latitude, position.longitude);
});