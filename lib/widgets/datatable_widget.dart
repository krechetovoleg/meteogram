import 'package:flutter/material.dart';
import '../controllers/color_controller.dart';
import '../theme/theme.dart';

class DataTableWidget extends StatelessWidget {
  final List<String> time;
  final List<double> temperature;
  final List<int> relativeHumidity;
  final List<double> windSpeed;
  final List<double> surfacePressure;

  DataTableWidget({
    super.key,
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.surfacePressure,
  });

  final mainBorderColor = ColorController();
  final double widthScreen = double.infinity;
  final TextStyle textStyle = const TextStyle(fontSize: 14.0, color: textColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: mainBorderColor.bColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 100,
          ),
        ],
      ),
      child: Card(
        color: backgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 12.0),
            const Padding(
              padding: EdgeInsets.only(top: 12.0, bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/time.png'),
                        size: 20.0,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/temp_plus.png'),
                        size: 20.0,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/pressure.png'),
                        size: 20.0,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/humidity.png'),
                        size: 20.0,
                        color: textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: ImageIcon(
                        AssetImage('assets/images/wind.png'),
                        size: 20.0,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: time.isNotEmpty
                  ? ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const Divider(color: textColor),
                      itemCount: time.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    time[index].substring(11, 16),
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    temperature[index].toString(),
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    surfacePressure[index].toString(),
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    relativeHumidity[index].toString(),
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    windSpeed[index].toString(),
                                    style: textStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : SizedBox(height: 0),
            ),
          ],
        ),
      ),
    );
  }
}
