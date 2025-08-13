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
      time: json['current']['time'],
      temperature: json['current']['temperature_2m'],
      relativeHumidity: json['current']['relative_humidity_2m'],
      apparentTemperature: json['current']['apparent_temperature'],
      precipitation: json['current']['precipitation'],
      rain: json['current']['rain'],
      showers: json['current']['showers'],
      snowfall: json['current']['snowfall'],
      weatherCode: json['current']['weather_code'],
      cloudCover: json['current']['cloud_cover'],
      pressureMsl: json['current']['pressure_msl'],
      surfacePressure: json['current']['surface_pressure'],
      windSpeed: json['current']['wind_speed_10m'],
      windDirection: json['current']['wind_direction_10m'],
      windGusts: json['current']['wind_gusts_10m'],
    );
  }
}
