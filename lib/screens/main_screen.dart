import 'package:flutter/material.dart';
import 'package:meteogram/models/current_weather_model.dart';
import 'package:meteogram/services/current_weather_services.dart';
import 'package:meteogram/models/city_search_model.dart';
import 'package:meteogram/services/city_search_servises.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CurrentWeatherServices _currentWeatherServices =
      CurrentWeatherServices();

  final CitySearchServises _citySearchServises = CitySearchServises();

  bool _isLoading = false;
  CurrentWeather? _currentWeather;
  CiySearch? _ciySearch;

  //final TextEditingController _controller = TextEditingController();

  void _getCurrentWeather() async {
    setState(() {
      _isLoading = true;
    });

    final currentWeather = await _currentWeatherServices.featchCurrentWeather(
      '55.0',
      '83.0',
    );

    setState(() {
      _currentWeather = currentWeather;
      _isLoading = false;
    });
  }

  void _getCityName(String cityName, String lang) async {
    setState(() {
      _isLoading = true;
    });

    final citySearch = await _citySearchServises.featchCitySearch(
      cityName,
      lang,
    );

    setState(() {
      _ciySearch = citySearch;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    //_getCurrentWeather(); //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(_currentWeather == null ? '' : _currentWeather!.time),
            Text(
              _currentWeather == null
                  ? ''
                  : _currentWeather!.apparentTemperature.toString(),
            ),
            Text(_ciySearch == null ? '' : _ciySearch!.cityName[0]),
            Text(_ciySearch == null ? '' : _ciySearch!.country[0]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          _getCurrentWeather();
          _getCityName('Новосиб', 'ru');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
