import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApiException implements Exception {
  final String message;
  WeatherApiException(this.message);

  @override
  String toString() => message;
}

class WeatherApiService {
  WeatherApiService(this.apiKey);

  final String apiKey;
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchByCity(String city) async {
    if (city.trim().isEmpty) {
      throw WeatherApiException('Il nome della città non può essere vuoto');
    }

    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$apiKey&units=metric&lang=it',
    );

    try {
      final res = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw WeatherApiException('Timeout: controlla la tua connessione');
            },
          );

      if (res.statusCode == 404) {
        throw WeatherApiException('Città "$city" non trovata. Verifica il nome.');
      } else if (res.statusCode == 401) {
        throw WeatherApiException('API Key non valida. Controlla la configurazione.');
      } else if (res.statusCode != 200) {
        throw WeatherApiException('Errore del server (${res.statusCode})');
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Weather.fromJson(data);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Errore di rete: ${e.toString()}');
    }
  }

  Future<Weather> fetchByLocation(double lat, double lon) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=it',
    );

    try {
      final res = await http.get(uri).timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw WeatherApiException('Timeout: controlla la tua connessione');
            },
          );

      if (res.statusCode == 401) {
        throw WeatherApiException('API Key non valida. Controlla la configurazione.');
      } else if (res.statusCode != 200) {
        throw WeatherApiException('Errore del server (${res.statusCode})');
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return Weather.fromJson(data);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Errore di rete: ${e.toString()}');
    }
  }
}