// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:meteogram/widgets/datatable_widget.dart';

import '../controllers/color_controller.dart';
import '../theme/theme.dart';

class TabWidget extends StatefulWidget {
  final List<String> time;
  final List<double> temperature;
  final List<int> relativeHumidity;
  final List<double> windSpeed;
  final List<double> surfacePressure;

  const TabWidget({
    super.key,
    required this.time,
    required this.temperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.surfacePressure,
  });

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var mainBorderColor = ColorController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: mainBorderColor.bColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'Суточные метеоданные',
            style: TextStyle(fontSize: 18.0, color: textColor),
          ),
          SizedBox(
            height: 40,
            child: TabBar(
              indicatorColor: mainBorderColor.bColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              dividerColor: mainBorderColor.bColor,
              controller: _tabController,
              tabs: const [
                ImageIcon(
                  AssetImage('assets/images/white/database.png'),
                  size: 22.0,
                  color: textColor,
                ),
                ImageIcon(
                  AssetImage('assets/images/white/line-chart.png'),
                  size: 22.0,
                  color: textColor,
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DataTableWidget(
                  time: widget.time,
                  temperature: widget.temperature,
                  relativeHumidity: widget.relativeHumidity,
                  windSpeed: widget.windSpeed,
                  surfacePressure: widget.surfacePressure,
                ),
                Text('MeteogramWidget'),
              ],
              //children: [DataTableWidget(), MeteogramWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
