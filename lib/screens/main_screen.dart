import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meteogram/widgets/cards_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/current_weather_model.dart';
import '../services/current_weather_services.dart';
import '../models/city_search_model.dart';
import '../services/city_search_servises.dart';
import '../theme/theme.dart';

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
  String timezonePref = "";
  String admin1Pref = "";

  void _getCurrentWeather(
    String latitude,
    String longitude,
    String timezone,
  ) async {
    final currentWeather = await _currentWeatherServices.featchCurrentWeather(
      latitude,
      longitude,
      timezone,
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
      timezonePref = prefs.getString('timezone') ?? "GMT";
      admin1Pref = prefs.getString('admin1') ?? "";

      if (cityNamePref != "") {
        countryPref = "($countryPref / $admin1Pref)";
        _searchController.text = "$cityNamePref $countryPref";
      }

      if (latitudePref != "" && longitudePref != "" && !onlyRead) {
        _getCurrentWeather(latitudePref, longitudePref, timezonePref);
      }
    });
  }

  Future<void> _savePref(
    String cityNamePref,
    String countryPref,
    String latitudePref,
    String longitudePref,
    String timezonePref,
    String admin1Pref,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('city', cityNamePref);
    prefs.setString('country', countryPref);
    prefs.setString('latitude', latitudePref);
    prefs.setString('longitude', longitudePref);
    prefs.setString('timezone', timezonePref);
    prefs.setString('admin1', admin1Pref);
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.initState();
    _readPref(false);
    _searchController.addListener(() {
      if (_searchController.text.length >= 3) {
        _getCityName(_searchController.text, 'ru');
        _visibleResultCity = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: textColor),
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
                  //color: textColor,
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
                      color: textColor,
                    ),
                    hintStyle: const TextStyle(color: textColor),
                    hintText: "Поиск...",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsetsGeometry.only(
                      left: 8,
                      right: 8,
                      top: 4,
                    ),
                  ),
                  style: const TextStyle(color: textColor),
                  onChanged: (value) {
                    setState(() {
                      _visibleSearchField = true;
                    });
                  },
                ),
              )
            : Text(
                "Метеограм",
                style: TextStyle(fontSize: 26, color: textColor),
              ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                                      _ciySearch!.timezone[index > 0
                                          ? (index - 1)
                                          : 0],
                                    ),
                                    _searchController.text =
                                        "${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]} / ${_ciySearch!.admin1[index > 0 ? (index - 1) : 0]})",
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
                                      timezonePref =
                                          _ciySearch!.timezone[index > 0
                                              ? (index - 1)
                                              : 0];

                                      admin1Pref = _ciySearch!
                                          .admin1[index > 0 ? (index - 1) : 0];
                                    }),

                                    _savePref(
                                      cityNamePref,
                                      countryPref,
                                      latitudePref,
                                      longitudePref,
                                      timezonePref,
                                      admin1Pref,
                                    ),

                                    _readPref(true),
                                  };
                          },
                          child: ListTile(
                            title: Text(
                              _ciySearch == null || _ciySearch!.cityName.isEmpty
                                  ? ""
                                  : "${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]} / ${_ciySearch!.admin1[index > 0 ? (index - 1) : 0]})",
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                            subtitle: Text(
                              _ciySearch == null || _ciySearch!.cityName.isEmpty
                                  ? ""
                                  : "lat: ${_ciySearch!.latitude[index > 0 ? (index - 1) : 0].toString()} ; lon: ${_ciySearch!.longitude[index > 0 ? (index - 1) : 0].toString()}",
                              style: TextStyle(fontSize: 14, color: textColor),
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(height: 0),
            ),

            Expanded(
              flex: 20,
              child: CardWidget(
                supTopStr: "$cityNamePref $countryPref",
                supTopSize: 18.0,
                topStr:
                    '${_currentWeather == null ? '' : _currentWeather!.temperature.toString()} °C',
                topSize: 36.0,
                centerStr:
                    'Ощущается как: ${_currentWeather == null ? '' : _currentWeather!.apparentTemperature.toString()} °C',
                centerSize: 18.0,
                bottomStr: _currentWeather == null
                    ? ''
                    : "${_currentWeather!.time.substring(8, 10)}.${_currentWeather!.time.substring(5, 7)}.${_currentWeather!.time.substring(0, 4)} ${_currentWeather!.time.substring(11, 16)}",
                bottomSize: 14.0,
                width: double.infinity,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
