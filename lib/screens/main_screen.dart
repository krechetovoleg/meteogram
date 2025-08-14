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
  bool _visibleResultCity = false;
  bool _visibleSearchField = false;
  final _searchController = TextEditingController();

  void _getCurrentWeather(String latitude, String longitude) async {
    setState(() {
      _isLoading = true;
    });

    final currentWeather = await _currentWeatherServices.featchCurrentWeather(
      latitude,
      longitude,
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
      cityName.trim(),
      lang.trim(),
    );

    setState(() {
      _ciySearch = citySearch;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.length >= 3) {
        _getCityName(_searchController.text, 'ru');
        _visibleResultCity = true;
      }
    });

    //_getCurrentWeather(); //running initialisation code; getting prefs etc.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _visibleSearchField = !_visibleSearchField;
                if (!_visibleSearchField) {
                  _searchController.text = "";
                  _currentWeather = null;
                }
              });
            },
            icon: Icon(_visibleSearchField ? Icons.clear : Icons.search),
          ),
        ],
        title: _visibleSearchField
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Поиск...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsetsGeometry.only(
                      left: 8,
                      right: 8,
                      bottom: 4,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _visibleSearchField = true;
                    });
                  },
                ),
              )
            : const Text("Метеограм"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible:
                  _searchController.text.isEmpty ||
                      _searchController.text.length < 3 ||
                      _visibleResultCity == false
                  ? false
                  : true,
              child: _ciySearch != null && _ciySearch!.cityName.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _ciySearch!.cityName.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _ciySearch == null || _ciySearch!.cityName.isEmpty
                                ? () {}
                                : {
                                    _getCurrentWeather(
                                      _ciySearch!
                                          .latitude[index > 0 ? (index - 1) : 0]
                                          .toString(),
                                      _ciySearch!
                                          .longitude[index > 0
                                              ? (index - 1)
                                              : 0]
                                          .toString(),
                                    ),
                                    _searchController.text = _ciySearch!
                                        .cityName[index > 0 ? (index - 1) : 0]
                                        .trim(),
                                    _visibleResultCity = false,
                                  };
                          },
                          child: ListTile(
                            title: Text(
                              _ciySearch == null || _ciySearch!.cityName.isEmpty
                                  ? ""
                                  : "${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]})",
                            ),
                            subtitle: Text(
                              _ciySearch == null || _ciySearch!.cityName.isEmpty
                                  ? ""
                                  : "lat: ${_ciySearch!.latitude[index > 0 ? (index - 1) : 0].toString()} ; lon: ${_ciySearch!.longitude[index > 0 ? (index - 1) : 0].toString()}",
                            ),
                          ),
                        );
                      },
                    )
                  : Center(child: Text('Нет данных')),
            ),
            Text(_currentWeather == null ? '' : _currentWeather!.time),
            Text(
              _currentWeather == null
                  ? ''
                  : _currentWeather!.apparentTemperature.toString(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          _getCurrentWeather('55.03442', '82.94339');
          _getCityName('Новосиб', 'ru');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
