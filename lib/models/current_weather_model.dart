class CurrentWeather {
  final String time;
  final double temperature;
  final int relativeHumidity;
  final double apparentTemperature;
  final double precipitation;
  final double rain;
  final double showers;
  final double snowfall;
  final int weatherCode;
  final int cloudCover;
  final double pressureMsl;
  final double surfacePressure;
  final double windSpeed;
  final int windDirection;
  final double windGusts;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.apparentTemperature,
    required this.precipitation,
    required this.rain,
    required this.showers,
    required this.snowfall,
    required this.weatherCode,
    required this.cloudCover,
    required this.pressureMsl,
    required this.surfacePressure,
    required this.windSpeed,
    required this.windDirection,
    required this.windGusts,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json['current']['time'] ?? '',
      temperature: json['current']['temperature_2m'] ?? 0.0,
      relativeHumidity: json['current']['relative_humidity_2m'] ?? 0,
      apparentTemperature: json['current']['apparent_temperature'] ?? 0.0,
      precipitation: json['current']['precipitation'] ?? 0.0,
      rain: json['current']['rain'] ?? 0.0,
      showers: json['current']['showers'] ?? 0.0,
      snowfall: json['current']['snowfall'] ?? 0.0,
      weatherCode: json['current']['weather_code'] ?? 0,
      cloudCover: json['current']['cloud_cover'] ?? 0,
      pressureMsl: json['current']['pressure_msl'] ?? 0.0,
      surfacePressure: json['current']['surface_pressure'] ?? 0.0,
      windSpeed: json['current']['wind_speed_10m'] ?? 0.0,
      windDirection: json['current']['wind_direction_10m'] ?? 0,
      windGusts: json['current']['wind_gusts_10m'] ?? 0.0,
    );
  }
}
