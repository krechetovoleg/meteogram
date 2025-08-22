import 'package:flutter/material.dart';

import '../controllers/color_controller.dart';
import '../models/current_weather_model.dart';
import '../theme/theme.dart';

class DetailsScreen extends StatelessWidget {
  final CurrentWeather? curWeather;

  DetailsScreen({super.key, required this.curWeather});

  final mainBorderColor = ColorController();
  final double widthScreen = double.infinity;

  String _windDir(int wd) {
    String res = '';

    if (wd >= 0 && wd <= 22) {
      res = 'Северное';
    } else if (wd >= 23 && wd <= 67) {
      res = 'Северо-Восточное';
    } else if (wd >= 68 && wd <= 112) {
      res = 'Восточное';
    } else if (wd >= 113 && wd <= 157) {
      res = 'Юго-Восточное';
    } else if (wd >= 158 && wd <= 202) {
      res = 'Южное';
    } else if (wd >= 203 && wd <= 247) {
      res = 'Юго-Западное';
    } else if (wd >= 248 && wd <= 292) {
      res = 'Западное';
    } else if (wd >= 293 && wd <= 337) {
      res = 'Северо-Западное';
    } else if (wd >= 338 && wd <= 360) {
      res = 'Северное';
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
        title: Text(
          'AzMeteoGram',
          style: TextStyle(fontSize: 26, color: textColor),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: textColor),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: curWeather == null || curWeather!.time.isNotEmpty
            ? Center(
                child: Column(
                  children: [
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Время измерения:',
                      valParam: curWeather == null
                          ? ''
                          : '${curWeather!.time.substring(8, 10)}.${curWeather!.time.substring(5, 7)}.${curWeather!.time.substring(0, 4)} ${curWeather!.time.substring(11, 16)}',
                      unitMeasure: '',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Температура:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.temperature.toString(),
                      unitMeasure: '°C',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Ощущается как:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.apparentTemperature.toString(),
                      unitMeasure: '°C',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Облачность:',
                      valParam: curWeather == null
                          ? ''
                          : _cloudCover(curWeather!.cloudCover),
                      unitMeasure: '',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Давление:',
                      valParam: curWeather == null
                          ? ''
                          : (curWeather!.surfacePressure / 1.333220)
                                .toStringAsFixed(2),
                      unitMeasure: '(мм.рр.ст.)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Влажность:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.relativeHumidity.toString(),
                      unitMeasure: '(%)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Скорость ветра:',
                      valParam: curWeather == null
                          ? ''
                          : (curWeather!.windSpeed / 3.6).toStringAsFixed(2),
                      unitMeasure: '(м/с)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Порывы ветра:',
                      valParam: curWeather == null
                          ? ''
                          : (curWeather!.windGusts / 3.6).toStringAsFixed(2),
                      unitMeasure: '(м/с)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Направление ветра:',
                      valParam: curWeather == null
                          ? ''
                          : _windDir(curWeather!.windDirection),
                      unitMeasure: '',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Дождь:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.rain.toString(),
                      unitMeasure: '(мм за послед.час)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Ливни:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.rain.toString(),
                      unitMeasure: '(мм за послед.час)',
                    ),
                    DetailsWidget(
                      mainBorderColor: mainBorderColor,
                      nameParam: 'Снег:',
                      valParam: curWeather == null
                          ? ''
                          : curWeather!.snowfall.toString(),
                      unitMeasure: '(см за послед.час)',
                    ),

                    Text(
                      'По данным сервиса https://open-meteo.com/',
                      style: TextStyle(fontSize: 10, color: textColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : SizedBox(height: 0),
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    super.key,
    required this.mainBorderColor,
    required this.nameParam,
    required this.valParam,
    required this.unitMeasure,
  });

  final ColorController mainBorderColor;
  final String nameParam;
  final String valParam;
  final String unitMeasure;

  final double widthScreen = double.infinity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: widthScreen,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: mainBorderColor.bColor.withAlpha((255.0 * 0.5).round()),
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
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      nameParam,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      '$valParam $unitMeasure',
                      style: TextStyle(fontSize: 14, color: textColor),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
