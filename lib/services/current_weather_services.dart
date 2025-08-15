import '../models/current_weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentWeatherServices {
  Future<CurrentWeather> featchCurrentWeather(
    String latitude,
    String longitude,
    String timezone,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${latitude.trim()}&longitude=${longitude.trim()}&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m&timezone=$timezone',
      );

      final responce = await http.get(url);

      if (responce.statusCode == 200) {
        return CurrentWeather.fromJson(json.decode(responce.body));
      } else {
        throw ("Ошибка! Получения текущих данных!");
      }
    } catch (e) {
      throw ("Ошибка! Получения текущих данных! $e.toString()");
    }
  }
}
