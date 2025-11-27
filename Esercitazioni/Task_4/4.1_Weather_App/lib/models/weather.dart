class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int conditionCode; 

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.conditionCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num).toDouble(),
      description: (json['weather'][0]['description'] as String),
      conditionCode: json['weather'][0]['id'] as int,
    );
  }
}
