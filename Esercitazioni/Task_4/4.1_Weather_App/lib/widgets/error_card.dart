import 'package:flutter/material.dart';
import '../services/weather_api_service.dart';
import '../providers/location_providers.dart';

class ErrorCard extends StatelessWidget {
  final Object error;

  const ErrorCard({
    super.key,
    required this.error,
  });

  String _getErrorMessage() {
    if (error is WeatherApiException) {
      return (error as WeatherApiException).message;
    } else if (error is LocationException) {
      return (error as LocationException).message;
    } else {
      return 'Si è verificato un errore inaspettato';
    }
  }

  IconData _getErrorIcon() {
    if (error is LocationException) {
      return Icons.location_off_rounded;
    } else if (error is WeatherApiException) {
      final message = (error as WeatherApiException).message.toLowerCase();
      if (message.contains('non trovata')) {
        return Icons.search_off_rounded;
      } else if (message.contains('api key')) {
        return Icons.key_off_rounded;
      } else if (message.contains('rete') || message.contains('timeout')) {
        return Icons.wifi_off_rounded;
      }
    }
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getErrorIcon(),
              color: Theme.of(context).colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Ops!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            if (error is WeatherApiException &&
                (error as WeatherApiException)
                    .message
                    .toLowerCase()
                    .contains('api key')) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1. Vai su openweathermap.org',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '2. Registrati gratuitamente',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '3. Copia la tua API key',
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      '4. Incollala in weather_providers.dart',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}