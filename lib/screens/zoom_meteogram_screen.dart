import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/color_controller.dart';
import '../models/hourly_weather_model.dart';
import '../theme/theme.dart';

class ZoomMeteogramScreen extends StatelessWidget {
  final List<String> time;
  final List<double> temperature;
  final List<int> relativeHumidity;
  final List<double> windSpeed;
  final List<double> surfacePressure;

  ZoomMeteogramScreen({
    super.key,
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.surfacePressure,
  });

  var mainBorderColor = ColorController();
  final zoomPanBehavior = ZoomPanBehavior(enablePinching: true);
  final double widthScreen = double.infinity;

  late List<HourlyWeatherChartData> hWCD = [
    for (int i = 0; i < time.length; i++)
      HourlyWeatherChartData(
        time[i].substring(11, 13),
        temperature[i],
        relativeHumidity[i],
        windSpeed[i],
        surfacePressure[i],
      ),
  ];

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
            child: SfCartesianChart(
              legend: const Legend(
                isVisible: true,
                textStyle: TextStyle(color: textColor, fontSize: 10.0),
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              crosshairBehavior: CrosshairBehavior(
                enable: true,
                activationMode: ActivationMode.longPress,
              ),
              zoomPanBehavior: zoomPanBehavior,
              plotAreaBorderWidth: 0,
              backgroundColor: backgroundColor,
              primaryXAxis: const CategoryAxis(
                title: AxisTitle(
                  text: 'Время',
                  textStyle: TextStyle(color: textColor, fontSize: 10),
                ),
              ),
              primaryYAxis: const NumericAxis(
                title: AxisTitle(
                  text: 'Температура - Влажность - Скорость ветра',
                  textStyle: TextStyle(color: textColor, fontSize: 10),
                ),
              ),
              tooltipBehavior: TooltipBehavior(enable: true),
              axes: const [
                NumericAxis(
                  name: 'yAsisPressure',
                  title: AxisTitle(
                    text: 'Давление',
                    textStyle: TextStyle(color: textColor, fontSize: 10),
                  ),
                  opposedPosition: true,
                  interval: 1.0,
                ),
              ],
              series: <CartesianSeries>[
                SplineSeries<HourlyWeatherChartData, String>(
                  name: 'Тем-ра',
                  dataSource: hWCD,
                  xValueMapper: (HourlyWeatherChartData val, _) => val.time,
                  yValueMapper: (HourlyWeatherChartData val, _) =>
                      val.temperature,
                ),
                SplineSeries<HourlyWeatherChartData, String>(
                  yAxisName: 'yAsisPressure',
                  name: 'Давление',
                  dataSource: hWCD,
                  xValueMapper: (HourlyWeatherChartData val, _) => val.time,
                  yValueMapper: (HourlyWeatherChartData val, _) =>
                      val.surfacePressure,
                ),
                SplineSeries<HourlyWeatherChartData, String>(
                  name: 'Влажность',
                  dataSource: hWCD,
                  xValueMapper: (HourlyWeatherChartData val, _) => val.time,
                  yValueMapper: (HourlyWeatherChartData val, _) =>
                      val.relativeHumidity,
                ),
                SplineSeries<HourlyWeatherChartData, String>(
                  name: 'Скорость ветра',
                  dataSource: hWCD,
                  xValueMapper: (HourlyWeatherChartData val, _) => val.time,
                  yValueMapper: (HourlyWeatherChartData val, _) =>
                      val.windSpeed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
