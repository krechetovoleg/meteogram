import 'package:meteogram/models/city_search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitySearchServises {
  Future<CiySearch> featchCitySearch(String cityName, String lang) async {
    // try {
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=10&language=$lang&format=json',
    );

    final responce = await http.get(url);

    if (responce.statusCode == 200) {
      return CiySearch.fromJson(json.decode(responce.body));
    } else {
      throw ('Ошибка! Получения текущих данных!');
    }
    //} catch (e) {
    //  throw ('Ошибка! Получения текущих данных!');
    // }
  }
}
