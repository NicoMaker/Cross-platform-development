import 'package:flutter/material.dart';

class WeatherUtils {
  // Ottiene l'icona appropriata in base al codice condizione
  static IconData getWeatherIcon(int conditionCode) {
    if (conditionCode >= 200 && conditionCode < 300) {
      return Icons.thunderstorm_rounded; // Temporale
    } else if (conditionCode >= 300 && conditionCode < 400) {
      return Icons.grain_rounded; // Pioggerella
    } else if (conditionCode >= 500 && conditionCode < 600) {
      return Icons.umbrella_rounded; // Pioggia
    } else if (conditionCode >= 600 && conditionCode < 700) {
      return Icons.ac_unit_rounded; // Neve
    } else if (conditionCode >= 700 && conditionCode < 800) {
      return Icons.foggy; // Nebbia/Atmosfera
    } else if (conditionCode == 800) {
      return Icons.wb_sunny_rounded; // Sereno
    } else if (conditionCode > 800 && conditionCode < 900) {
      return Icons.cloud_rounded; // Nuvoloso
    }
    return Icons.help_outline_rounded;
  }

  // Ottiene i colori del gradiente in base alla condizione meteo
  static List<Color> getWeatherGradient(int conditionCode) {
    // Temporale
    if (conditionCode >= 200 && conditionCode < 300) {
      return [
        const Color(0xFF4A5568),
        const Color(0xFF1A202C),
      ];
    }
    // Pioggerella/Pioggia
    else if (conditionCode >= 300 && conditionCode < 600) {
      return [
        const Color(0xFF667EEA),
        const Color(0xFF764BA2),
      ];
    }
    // Neve
    else if (conditionCode >= 600 && conditionCode < 700) {
      return [
        const Color(0xFFE0F2FE),
        const Color(0xFF7DD3FC),
      ];
    }
    // Nebbia/Atmosfera
    else if (conditionCode >= 700 && conditionCode < 800) {
      return [
        const Color(0xFF9CA3AF),
        const Color(0xFF6B7280),
      ];
    }
    // Sereno
    else if (conditionCode == 800) {
      return [
        const Color(0xFF60A5FA),
        const Color(0xFF3B82F6),
      ];
    }
    // Nuvoloso
    else if (conditionCode > 800 && conditionCode < 900) {
      return [
        const Color(0xFF94A3B8),
        const Color(0xFF64748B),
      ];
    }
    // Default
    return [
      const Color(0xFF60A5FA),
      const Color(0xFF3B82F6),
    ];
  }

  // Ottiene una descrizione testuale della condizione meteo
  static String getWeatherDescription(int conditionCode) {
    if (conditionCode >= 200 && conditionCode < 300) {
      return 'Temporale';
    } else if (conditionCode >= 300 && conditionCode < 400) {
      return 'Pioggerella';
    } else if (conditionCode >= 500 && conditionCode < 600) {
      return 'Pioggia';
    } else if (conditionCode >= 600 && conditionCode < 700) {
      return 'Neve';
    } else if (conditionCode >= 700 && conditionCode < 800) {
      return 'Nebbia';
    } else if (conditionCode == 800) {
      return 'Sereno';
    } else if (conditionCode > 800 && conditionCode < 900) {
      return 'Nuvoloso';
    }
    return 'Sconosciuto';
  }
}