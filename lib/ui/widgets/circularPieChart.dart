import 'package:expends/database/data/categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';

class CircularPieChart extends StatelessWidget {
  List<CircularStackEntry> chartData;
  final GlobalKey<AnimatedCircularChartState> _chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  CircularPieChart(List<Map> data) {
    List<CircularSegmentEntry> entryList = [];

    for (var i = 0; i < data.length; i++) {
      var map = data[i];
      Categories cat = map['category'];
      entryList.add(new CircularSegmentEntry(
          double.parse(map['expend']), Color(int.parse(cat.color)),
          rankKey: cat.id.toString()));
    }

    this.chartData = <CircularStackEntry>[
      CircularStackEntry(
        entryList,
        rankKey: "",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new AnimatedCircularChart(
      key: _chartKey,
      size: const Size(200.0, 200.0),
      initialChartData: chartData,
      chartType: CircularChartType.Pie,
      holeRadius: 80,
    );
  }
}
