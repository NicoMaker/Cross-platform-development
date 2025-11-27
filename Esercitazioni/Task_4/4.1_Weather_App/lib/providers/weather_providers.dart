import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';

const kOpenWeatherApiKey = 'LA_TUA_API_KEY';

final weatherApiServiceProvider = Provider<WeatherApiService>((ref) {
  return WeatherApiService(kOpenWeatherApiKey);
});

// SharedPreferences provider
final sharedPrefsProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

const _kLastCityKey = 'last_city';
const _kFavoritesKey = 'favorite_cities';

final selectedCityProvider =
    StateNotifierProvider<SelectedCityNotifier, String?>(
  (ref) => SelectedCityNotifier(ref),
);

class SelectedCityNotifier extends StateNotifier<String?> {
  SelectedCityNotifier(this.ref) : super(null) {
    _loadInitial();
  }

  final Ref ref;

  Future<void> _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kLastCityKey) ?? 'Udine';
  }

  Future<void> setCity(String city) async {
    state = city;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastCityKey, city);
  }
}

final weatherForSelectedCityProvider = FutureProvider<Weather>((ref) async {
  final city = ref.watch(selectedCityProvider);
  if (city == null || city.isEmpty) {
    throw Exception('Nessuna città selezionata');
  }
  final api = ref.watch(weatherApiServiceProvider);
  return api.fetchByCity(city);
});

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
    if (!state.contains(city)) {
      state = [...state, city];
      await _save();
    }
  }

  Future<void> removeFavorite(String city) async {
    state = state.where((c) => c != city).toList();
    await _save();
  }
}
