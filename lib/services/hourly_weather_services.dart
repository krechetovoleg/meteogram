import '../models/hourly_weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HourlyWeatherServices {
  Future<HourlyWeather> featchHourlyWeather(
    String latitude,
    String longitude,
    String timezone,
  ) async {
    try {
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=${latitude.trim()}&longitude=${longitude.trim()}&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m,surface_pressure,&timezone=$timezone&forecast_days=1',
      );

      final responce = await http.get(url);

      if (responce.statusCode == 200) {
        return HourlyWeather.fromJson(json.decode(responce.body));
      } else {
        throw ("Ошибка! Получения текущих данных!");
      }
    } catch (e) {
      throw ("Ошибка! Получения текущих данных! $e.toString()");
    }
  }
}
