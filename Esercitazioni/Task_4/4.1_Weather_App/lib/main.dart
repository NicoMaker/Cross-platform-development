import 'package:flutter/material.dart';import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/weather_providers.dart';
import 'providers/location_providers.dart';

void main() {
  runApp(const ProviderScope(child: WeatherApp()));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key});

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchCity() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      ref.read(selectedCityProvider.notifier).setCity(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherForSelectedCityProvider);
    final favorites = ref.watch(favoritesProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () async {
              // Carica meteo da posizione e aggiorna città con il nome della risposta
              final locWeather =
                  await ref.read(weatherForCurrentLocationProvider.future);
              ref
                  .read(selectedCityProvider.notifier)
                  .setCity(locWeather.cityName);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo di ricerca
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Cerca città',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchCity(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchCity,
                  child: const Text('Cerca'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Meteo corrente (loading / error / data)
            Expanded(
              child: weatherAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => Center(
                  child: Text(
                    'Errore: $err',
                    textAlign: TextAlign.center,
                  ),
                ),
                data: (weather) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather.cityName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${weather.temperature.toStringAsFixed(1)} °C',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.description,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.star),
                            label: const Text('Aggiungi ai preferiti'),
                            onPressed: selectedCity == null
                                ? null
                                : () {
                                    ref
                                        .read(favoritesProvider.notifier)
                                        .addFavorite(selectedCity);
                                  },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Preferiti:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: favorites.isEmpty
                            ? const Text('Nessuna città favorita')
                            : ListView.builder(
                                itemCount: favorites.length,
                                itemBuilder: (context, index) {
                                  final city = favorites[index];
                                  return ListTile(
                                    title: Text(city),
                                    onTap: () {
                                      ref
                                          .read(selectedCityProvider.notifier)
                                          .setCity(city);
                                    },
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        ref
                                            .read(
                                              favoritesProvider.notifier,
                                            )
                                            .removeFavorite(city);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
