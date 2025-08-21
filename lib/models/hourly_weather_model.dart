class HourlyWeatherChartData {
  HourlyWeatherChartData(
    this.time,
    this.temperature,
    this.relativeHumidity,
    this.windSpeed,
    this.surfacePressure,
  );
  final String time;
  final double temperature;
  final int relativeHumidity;
  final double windSpeed;
  final double surfacePressure;
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;
  final List<int> relativeHumidity;
  final List<double> windSpeed;
  final List<double> surfacePressure;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.surfacePressure,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    var hours = HourlyWeather(
      time: [],
      temperature: [],
      relativeHumidity: [],
      windSpeed: [],
      surfacePressure: [],
    );

    if (json.length > 1) {
      for (int i = 0; i < json['hourly']['time'].length; i++) {
        hours.time.add(json['hourly']['time'][i] ?? '');
        hours.temperature.add(json['hourly']['temperature_2m'][i] ?? 0.0);
        hours.relativeHumidity.add(
          json['hourly']['relative_humidity_2m'][i] ?? 0,
        );
        hours.windSpeed.add(json['hourly']['wind_speed_10m'][i] ?? 0.0);
        hours.surfacePressure.add(json['hourly']['surface_pressure'][i] ?? 0.0);
      }
    }
    return hours;
  }
}
