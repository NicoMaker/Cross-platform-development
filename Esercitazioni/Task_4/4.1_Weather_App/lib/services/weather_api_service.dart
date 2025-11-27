import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherApiService {
  WeatherApiService(this.apiKey);

  final String apiKey;
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchByCity(String city) async {
    final uri = Uri.parse(
      '$_baseUrl?q=$city&appid=$apiKey&units=metric&lang=it',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Errore HTTP: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(data);
  }

  Future<Weather> fetchByLocation(double lat, double lon) async {
    final uri = Uri.parse(
      '$_baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=it',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Errore HTTP: ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return Weather.fromJson(data);
  }
}
