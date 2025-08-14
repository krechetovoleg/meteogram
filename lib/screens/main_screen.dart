import 'package:flutter/material.dart';
import 'package:meteogram/models/current_weather_model.dart';
import 'package:meteogram/services/current_weather_services.dart';
import 'package:meteogram/models/city_search_model.dart';
import 'package:meteogram/services/city_search_servises.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CurrentWeatherServices _currentWeatherServices =
      CurrentWeatherServices();

  final CitySearchServises _citySearchServises = CitySearchServises();

  CurrentWeather? _currentWeather;
  CiySearch? _ciySearch;
  bool _visibleResultCity = false;
  bool _visibleSearchField = false;
  final _searchController = TextEditingController();
  String cityNamePref = "";
  String countryPref = "";
  String latitudePref = "";
  String longitudePref = "";

  void _getCurrentWeather(String latitude, String longitude) async {
    final currentWeather = await _currentWeatherServices.featchCurrentWeather(
      latitude,
      longitude,
    );

    setState(() {
      _currentWeather = currentWeather;
    });
  }

  void _getCityName(String cityName, String lang) async {
    final citySearch = await _citySearchServises.featchCitySearch(
      cityName.trim(),
      lang.trim(),
    );

    setState(() {
      _ciySearch = citySearch;
    });
  }

  Future<void> _readPref(bool onlyRead) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cityNamePref = prefs.getString('city') ?? "";
      countryPref = prefs.getString('country') ?? "";
      latitudePref = prefs.getString('latitude') ?? "";
      longitudePref = prefs.getString('longitude') ?? "";

      if (cityNamePref != "") {
        countryPref = "($countryPref)";
        _searchController.text = "$cityNamePref $countryPref";
      }

      if (latitudePref != "" && longitudePref != "" && !onlyRead) {
        _getCurrentWeather(latitudePref, longitudePref);
      }
    });
  }

  Future<void> _savePref(
    String cityNamePref,
    String countryPref,
    String latitudePref,
    String longitudePref,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city', cityNamePref);
    prefs.setString('country', countryPref);
    prefs.setString('latitude', latitudePref);
    prefs.setString('longitude', longitudePref);
  }

  @override
  void initState() {
    super.initState();
    _readPref(false);
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
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _visibleSearchField = !_visibleSearchField;
                  });
                },
                icon: Icon(_visibleSearchField ? Icons.clear : Icons.search),
              ),
            ],
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
                  autofocus: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.text = "";
                      },
                      icon: const Icon(Icons.cancel_outlined),
                    ),
                    hintStyle: const TextStyle(color: Colors.black),
                    hintText: "Поиск...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsetsGeometry.only(
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
                                    _searchController.text =
                                        "${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]})",
                                    setState(() {
                                      _visibleResultCity = false;
                                      _visibleSearchField = false;
                                      cityNamePref =
                                          _ciySearch!.cityName[index > 0
                                              ? (index - 1)
                                              : 0];
                                      countryPref = _ciySearch!
                                          .country[index > 0 ? (index - 1) : 0];
                                      latitudePref = _ciySearch!
                                          .latitude[index > 0 ? (index - 1) : 0]
                                          .toString();
                                      longitudePref = _ciySearch!
                                          .longitude[index > 0
                                              ? (index - 1)
                                              : 0]
                                          .toString();
                                    }),

                                    _savePref(
                                      cityNamePref,
                                      countryPref,
                                      latitudePref,
                                      longitudePref,
                                    ),

                                    _readPref(true),
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
                  : Center(child: Text('')),
            ),
            Center(child: Text("$cityNamePref $countryPref")),
            Center(
              child: Text(_currentWeather == null ? '' : _currentWeather!.time),
            ),
            Center(
              child: Text(
                _currentWeather == null
                    ? ''
                    : _currentWeather!.apparentTemperature.toString(),
              ),
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff03dac6),
        foregroundColor: Colors.black,
        onPressed: () {
          _getCurrentWeather('55.03442', '82.94339');
          _getCityName('Новосиб', 'ru');
        },
        child: Icon(Icons.add),
      ),*/
    );
  }
}
