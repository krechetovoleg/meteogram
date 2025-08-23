import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/hourly_weather_services.dart';
import '../controllers/color_controller.dart';
import '../models/hourly_weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/cards_widget.dart';
import '../widgets/tab_widget.dart';
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
  final HourlyWeatherServices _hourlyWeatherServices = HourlyWeatherServices();
  var mainBorderColor = ColorController();

  CurrentWeather? _currentWeather;
  CiySearch? _ciySearch;
  HourlyWeather? _hourlyWeather;

  bool isloading = true;

  bool _visibleSearchField = false;
  final _searchController = TextEditingController();
  String cityNamePref = '';
  String countryPref = '';
  String latitudePref = '';
  String longitudePref = '';
  String timezonePref = '';
  String admin1Pref = '';

  late double widthScreen = MediaQuery.of(context).size.width;
  late double heightScreen = MediaQuery.of(context).size.height;

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

  void _getHourlyWeather(
    String latitude,
    String longitude,
    String timezone,
  ) async {
    final hourlyWeather = await _hourlyWeatherServices.featchHourlyWeather(
      latitude,
      longitude,
      timezone,
    );

    setState(() {
      _hourlyWeather = hourlyWeather;
    });
  }

  Future<void> _readPref(bool onlyRead) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
      cityNamePref = prefs.getString('city') ?? '';
      countryPref = prefs.getString('country') ?? '';
      latitudePref = prefs.getString('latitude') ?? '';
      longitudePref = prefs.getString('longitude') ?? '';
      timezonePref = prefs.getString('timezone') ?? 'GMT';
      admin1Pref = prefs.getString('admin1') ?? '';

      if (cityNamePref != '') {
        countryPref = '($countryPref / $admin1Pref)';
        _searchController.text = '$cityNamePref $countryPref';
      } else {
        cityNamePref = 'Москва';
        countryPref = '(Россия / Москва)';
        _searchController.text = 'Москва (Россия / Москва)';
        latitudePref = '55.75';
        longitudePref = '37.625';
        timezonePref = 'Europe/Moscow';
      }

      if (latitudePref != '' && longitudePref != '') {
        _getCurrentWeather(latitudePref, longitudePref, timezonePref);
        _getHourlyWeather(latitudePref, longitudePref, timezonePref);
      }
      isloading = false;
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

    _readPref(true);
    _searchController.addListener(() {
      if (_searchController.text.length >= 3) {
        _getCityName(_searchController.text, 'ru');
      }
    });
  }

  String _windDir(int wd) {
    String res = '';

    if (wd >= 0 && wd <= 22) {
      res = 'С';
    } else if (wd >= 23 && wd <= 67) {
      res = 'СВ';
    } else if (wd >= 68 && wd <= 112) {
      res = 'В';
    } else if (wd >= 113 && wd <= 157) {
      res = 'ЮВ';
    } else if (wd >= 158 && wd <= 202) {
      res = 'Ю';
    } else if (wd >= 203 && wd <= 247) {
      res = 'ЮЗ';
    } else if (wd >= 248 && wd <= 292) {
      res = 'З';
    } else if (wd >= 293 && wd <= 337) {
      res = 'СЗ';
    } else if (wd >= 338 && wd <= 360) {
      res = 'С';
    }

    return res;
  }

  String _cloudCover(int cc) {
    String res = '';
    if (cc >= 0 && cc <= 10) {
      res = 'ясно';
    } else if (cc >= 11 && cc <= 29) {
      res = 'преимущественно ясно';
    } else if (cc >= 30 && cc <= 45) {
      res = 'переменная облачность';
    } else if (cc >= 46 && cc <= 70) {
      res = 'облачно с прояснениями';
    } else if (cc >= 71 && cc <= 90) {
      res = 'преимущественно облачно';
    } else if (cc >= 91 && cc <= 100) {
      res = 'облачно';
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: textColor),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _visibleSearchField = !_visibleSearchField;
              });
            },
            icon: Icon(_visibleSearchField ? Icons.clear : Icons.search),
          ),
        ],
        title: _visibleSearchField
            ? Container(
                width: widthScreen,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: mainBorderColor.bColor.withAlpha(
                        (255.0 * 0.5).round(),
                      ),
                      spreadRadius: 2,
                      blurRadius: 100,
                    ),
                  ],
                ),
                child: Card(
                  color: backgroundColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: mainBorderColor.bColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _searchController.text = '';
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        color: textColor,
                      ),
                      hintStyle: const TextStyle(color: textColor),
                      hintText: 'Поиск...',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsetsGeometry.only(
                        left: 8,
                        right: 8,
                        top: 12,
                      ),
                    ),
                    style: const TextStyle(color: textColor),
                    onChanged: (value) {
                      setState(() {
                        _visibleSearchField = true;
                      });
                    },
                  ),
                ),
              )
            : Text(
                'AzMeteoGram',
                style: TextStyle(fontSize: 26, color: textColor),
              ),
      ),
      backgroundColor: backgroundColor,
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: IndexedStack(
                index: _visibleSearchField == true ? 1 : 0,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 25,
                        child: CardWidget(
                          supTopStr: cityNamePref,
                          supTopSize: 16.0,
                          supTopStr2: countryPref,
                          supTopSize2: 12.0,
                          topStr:
                              '${_currentWeather == null ? '' : _currentWeather!.temperature.toString()} °C',
                          topSize: 30.0,
                          centerStr:
                              'Ощущается как: ${_currentWeather == null ? '' : _currentWeather!.apparentTemperature.toString()} °C',
                          centerSize: 14.0,

                          centerBottomStr: _currentWeather == null
                              ? ''
                              : _cloudCover(_currentWeather!.cloudCover),
                          centerBottomSize: 12.0,
                          bottomStr: _currentWeather == null
                              ? ''
                              : '${_currentWeather!.time.substring(8, 10)}.${_currentWeather!.time.substring(5, 7)}.${_currentWeather!.time.substring(0, 4)} ${_currentWeather!.time.substring(11, 16)}',
                          bottomSize: 10.0,
                          width: widthScreen,
                          curWeather: _currentWeather,
                        ),
                      ),
                      Expanded(
                        flex: 15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 1,
                              child: CardWidgetSmall(
                                topStr: 'assets/images/pressure.png',
                                topSize: 24.0,
                                bottomStr: _currentWeather == null
                                    ? ''
                                    : (_currentWeather!.surfacePressure /
                                              1.333220)
                                          .toStringAsFixed(2),
                                bottomSize: 18,
                                width: (widthScreen * 0.28).roundToDouble(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CardWidgetSmall(
                                topStr: 'assets/images/humidity.png',
                                topSize: 24.0,
                                bottomStr: _currentWeather == null
                                    ? ''
                                    : _currentWeather!.relativeHumidity
                                          .toStringAsFixed(2),
                                bottomSize: 18,
                                width: (widthScreen * 0.28).roundToDouble(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: CardWidgetSmall(
                                topStr: 'assets/images/wind.png',
                                topSize: 24.0,
                                bottomStr: _currentWeather == null
                                    ? ''
                                    : '${(_currentWeather!.windSpeed / 3.6).toStringAsFixed(2)} ${_windDir(_currentWeather!.windDirection)}',
                                bottomSize: 18,
                                width: (widthScreen * 0.28).roundToDouble(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 60,
                        child: TabWidget(
                          time: _hourlyWeather == null
                              ? []
                              : _hourlyWeather!.time,
                          temperature: _hourlyWeather == null
                              ? []
                              : _hourlyWeather!.temperature,
                          relativeHumidity: _hourlyWeather == null
                              ? []
                              : _hourlyWeather!.relativeHumidity,
                          windSpeed: _hourlyWeather == null
                              ? []
                              : _hourlyWeather!.windSpeed,
                          surfacePressure: _hourlyWeather == null
                              ? []
                              : _hourlyWeather!.surfacePressure,
                        ),
                      ),
                    ],
                  ),

                  SingleChildScrollView(
                    child: _ciySearch != null && _ciySearch!.cityName.isNotEmpty
                        ? Container(
                            width: widthScreen,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: mainBorderColor.bColor.withAlpha(
                                    (255.0 * 0.5).round(),
                                  ),
                                  spreadRadius: 2,
                                  blurRadius: 100,
                                ),
                              ],
                            ),
                            child: Card(
                              color: backgroundColor,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: mainBorderColor.bColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _ciySearch!.cityName.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      _ciySearch == null ||
                                              _ciySearch!.cityName.isEmpty
                                          ? () {}
                                          : {
                                              _getCurrentWeather(
                                                _ciySearch!
                                                    .latitude[index > 0
                                                        ? (index - 1)
                                                        : 0]
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
                                                  '${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]} / ${_ciySearch!.admin1[index > 0 ? (index - 1) : 0]})',
                                              setState(() {
                                                _visibleSearchField = false;
                                                cityNamePref =
                                                    _ciySearch!.cityName[index >
                                                            0
                                                        ? (index - 1)
                                                        : 0];
                                                countryPref =
                                                    _ciySearch!.country[index >
                                                            0
                                                        ? (index - 1)
                                                        : 0];
                                                latitudePref = _ciySearch!
                                                    .latitude[index > 0
                                                        ? (index - 1)
                                                        : 0]
                                                    .toString();
                                                longitudePref = _ciySearch!
                                                    .longitude[index > 0
                                                        ? (index - 1)
                                                        : 0]
                                                    .toString();
                                                timezonePref =
                                                    _ciySearch!.timezone[index >
                                                            0
                                                        ? (index - 1)
                                                        : 0];

                                                admin1Pref =
                                                    _ciySearch!.admin1[index > 0
                                                        ? (index - 1)
                                                        : 0];
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
                                        _ciySearch == null ||
                                                _ciySearch!.cityName.isEmpty
                                            ? ''
                                            : '${_ciySearch!.cityName[index > 0 ? (index - 1) : 0]} (${_ciySearch!.country[index > 0 ? (index - 1) : 0]} / ${_ciySearch!.admin1[index > 0 ? (index - 1) : 0]})',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: textColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        _ciySearch == null ||
                                                _ciySearch!.cityName.isEmpty
                                            ? ''
                                            : 'lat: ${_ciySearch!.latitude[index > 0 ? (index - 1) : 0].toString()} ; lon: ${_ciySearch!.longitude[index > 0 ? (index - 1) : 0].toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : SizedBox(height: 0),
                  ),
                ],
              ),
            ),
    );
  }
}
