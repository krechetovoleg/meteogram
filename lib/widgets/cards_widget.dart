import 'package:flutter/material.dart';
import '../controllers/color_controller.dart';
import '../theme/theme.dart';

class CardWidget extends StatelessWidget {
  final String supTopStr;
  final double supTopSize;
  final String topStr;
  final double topSize;
  final String centerStr;
  final double centerSize;
  final String bottomStr;
  final double bottomSize;
  final double width;

  const CardWidget({
    super.key,
    required this.supTopStr,
    required this.supTopSize,
    required this.topStr,
    required this.topSize,
    required this.centerStr,
    required this.centerSize,
    required this.bottomStr,
    required this.bottomSize,
    required this.width,
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
            color: mainBorderColor.bColor.withOpacity(0.5),
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
        child: Center(
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
                    style: TextStyle(fontSize: supTopSize, color: textColor),
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
                    style: TextStyle(fontSize: centerSize, color: textColor),
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
                    style: TextStyle(fontSize: bottomSize, color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
