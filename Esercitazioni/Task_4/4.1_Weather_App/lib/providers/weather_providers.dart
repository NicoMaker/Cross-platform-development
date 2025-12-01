import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/weather.dart';
import '../services/weather_api_service.dart';

// IMPORTANTE: metti qui la tua API key di OpenWeatherMap
// Registrati su: https://openweathermap.org/api
const kOpenWeatherApiKey = 'LA_TUA_API_KEY';

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  return WeatherApiService(kOpenWeatherApiKey);
});

const _kLastCityKey = 'last_city';
const _kFavoritesKey = 'favorite_cities';

// Provider per la città selezionata
final selectedCityProvider =
    StateNotifierProvider<SelectedCityNotifier, String?>(
  (ref) => SelectedCityNotifier(),
);

class SelectedCityNotifier extends StateNotifier<String?> {
  SelectedCityNotifier() : super(null) {
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kLastCityKey) ?? 'Udine';
  }

  Future<void> setCity(String city) async {
    if (city.trim().isEmpty) return;
    state = city.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastCityKey, state!);
  }
}

// Provider per il meteo della città selezionata
final weatherForSelectedCityProvider = FutureProvider<Weather>((ref) async {
  final city = ref.watch(selectedCityProvider);

  if (city == null || city.isEmpty) {
    throw WeatherApiException('Nessuna città selezionata');
  }

  if (kOpenWeatherApiKey.isEmpty ||
      kOpenWeatherApiKey == 'LA_TUA_API_KEY') {
    throw WeatherApiException(
      'API Key mancante! Inseriscila in providers/weather_providers.dart',
    );
  }

  final api = ref.watch(weatherApiServiceProvider);
  return api.fetchByCity(city);
});

// Provider per le città preferite
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<String>>(
  (ref) => FavoritesNotifier(),
);

class FavoritesNotifier extends StateNotifier<List<String>> {
  FavoritesNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kFavoritesKey) ?? [];
    state = list;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kFavoritesKey, state);
  }

  Future<void> addFavorite(String city) async {
    if (city.trim().isEmpty) return;
    final trimmedCity = city.trim();
    if (!state.contains(trimmedCity)) {
      state = [...state, trimmedCity];
      await _save();
    }
  }

  Future<void> removeFavorite(String city) async {
    state = state.where((c) => c != city).toList();
    await _save();
  }

  bool isFavorite(String? city) {
    if (city == null) return false;
    return state.contains(city);
  }
}
