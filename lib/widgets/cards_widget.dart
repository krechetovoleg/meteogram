import 'package:flutter/material.dart';
import '../controllers/color_controller.dart';
import '../models/current_weather_model.dart';
import '../screens/details_screen.dart';
import '../theme/theme.dart';

class CardWidget extends StatelessWidget {
  final String supTopStr;
  final double supTopSize;
  final String supTopStr2;
  final double supTopSize2;
  final String topStr;
  final double topSize;
  final String centerStr;
  final double centerSize;
  final String centerBottomStr;
  final double centerBottomSize;
  final String bottomStr;
  final double bottomSize;
  final double width;
  final CurrentWeather? curWeather;

  const CardWidget({
    super.key,
    required this.supTopStr,
    required this.supTopSize,
    required this.supTopStr2,
    required this.supTopSize2,
    required this.topStr,
    required this.topSize,
    required this.centerStr,
    required this.centerSize,
    required this.centerBottomStr,
    required this.centerBottomSize,
    required this.bottomStr,
    required this.bottomSize,
    required this.width,
    required this.curWeather,
  });

  @override
  Widget build(BuildContext context) {
    var mainBorderColor = ColorController();

    return Container(
      width: width,
      height: 200,
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
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) =>
                          DetailsScreen(curWeather: curWeather!),
                    ),
                  );
                },
                icon: Icon(Icons.my_library_books_outlined, color: textColor),
              ),
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        supTopStr,
                        style: TextStyle(
                          fontSize: supTopSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        supTopStr2,
                        style: TextStyle(
                          fontSize: supTopSize2,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        topStr,
                        style: TextStyle(fontSize: topSize, color: textColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        centerStr,
                        style: TextStyle(
                          fontSize: centerSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        centerBottomStr,
                        style: TextStyle(
                          fontSize: centerBottomSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12.0,
                        top: 2,
                        right: 12,
                        bottom: 2,
                      ),
                      child: Text(
                        bottomStr,
                        style: TextStyle(
                          fontSize: bottomSize,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardWidgetSmall extends StatelessWidget {
  final String topStr;
  final double topSize;
  final String bottomStr;
  final double bottomSize;
  final double width;

  const CardWidgetSmall({
    super.key,
    required this.topStr,
    required this.topSize,
    required this.bottomStr,
    required this.bottomSize,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final mainBorderColor = ColorController();

    return Container(
      width: width,
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 12, right: 12),
                child: ImageIcon(
                  AssetImage(topStr),
                  size: topSize,
                  color: textColor,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  top: 2,
                  right: 12,
                  bottom: 12,
                ),
                child: Text(
                  bottomStr,
                  style: TextStyle(fontSize: bottomSize, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
