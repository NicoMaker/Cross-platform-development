import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../providers/weather_providers.dart';
import '../providers/location_providers.dart';
import '../widgets/weather_card.dart';
import '../widgets/error_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/favorites_list.dart';

class WeatherHomePage extends ConsumerStatefulWidget {
  const WeatherHomePage({super.key});

  @override
  ConsumerState<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends ConsumerState<WeatherHomePage> {
  final _controller = TextEditingController();
  bool _isLoadingLocation = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchCity() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      ref.read(selectedCityProvider.notifier).setCity(city);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final weather = await ref.read(weatherForCurrentLocationProvider.future);
      ref.read(selectedCityProvider.notifier).setCity(weather.cityName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📍 Meteo per ${weather.cityName}'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherForSelectedCityProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Weather Hub',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          if (_isLoadingLocation)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.my_location_rounded),
              tooltip: 'Usa posizione corrente',
              onPressed: _useCurrentLocation,
            ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(weatherForSelectedCityProvider);
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Barra di ricerca
                      SearchBarWidget(
                        controller: _controller,
                        selectedCity: selectedCity,
                        onSearch: _searchCity,
                      ),
                      const SizedBox(height: 20),

                      // Card del meteo
                      weatherAsync.when(
                        loading: () => const _LoadingCard(),
                        error: (error, _) => ErrorCard(error: error),
                        data: (weather) => WeatherCard(weather: weather),
                      ),
                      const SizedBox(height: 24),

                      // Sezione preferiti
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Città Preferite',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Divider()),
              const FavoritesList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 200,
        alignment: Alignment.center,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Caricamento meteo...'),
          ],
        ),
      ),
    );
  }
}