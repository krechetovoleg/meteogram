import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meteogram/models/current_weather_model.dart';
import 'package:meteogram/services/current_weather_services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CurrentWeatherServices _currentWeatherServices =
      CurrentWeatherServices();
  bool _isLoading = false;
  CurrentWeather? _currentWeather;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(
          _currentWeather == null
              ? ''
              : _currentWeather!.apparentTemperature.toString(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          _getCurrentWeather();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
