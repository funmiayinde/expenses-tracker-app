import 'dart:async';

import 'package:intl/intl.dart';

import '../../../database/data/expends_model.dart';
import '../../../database/data/expends_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthWiseExpensesBloc {
  final _provider = ExpendsProvider();

  Future<List<dynamic>> getAllMonths() {
    return _provider.getAllMonths();
  }

  Future<double> getTotalExpenseOfMonth(String month) {
    return _provider.getTotalExpenseOfMonth(month);
  }

  Future<List<dynamic>> getAllDates(String month) {
    return _provider.getAllDates(month);
  }

  Future<double> getTotalExpenseOfDate(String date) {
    return _provider.getTotalExpenseOfDate(date);
  }

  Future<List<ExpendsModel>> getExpensesInGroup(String date) {
    return _provider.getExpensesInGroup(date);
  }

  Future<List<charts.Series<Map, String>>> getDailyExpenseChartData(
      String month) async {
    List<dynamic> dates = await getAllDates(month);

    List<Map> chartData = await _getExpensesForDates(dates);

    var chartDataList = await _prepareList(chartData.reversed.toList());

    return chartDataList;
  }

  Future<List<Map>> _getExpensesForDates(List<dynamic> dates) {
    Completer<List<Map>> _completer = new Completer();
    List<Map> chartData = [];
    int tempCount = 0;
    if (dates.isEmpty) {
      _completer.complete([]);
    }
    dates.forEach((date) async {
      double totalExpense = await getTotalExpenseOfDate(date);
      chartData.add({
        "date": date,
        "expense": totalExpense,
      });

      tempCount++;
      if (tempCount == dates.length) {
        _completer.complete(chartData);
      }
    });

    return _completer.future;
  }

  Future<List<charts.Series<Map, String>>> _prepareList(
      List<Map> chartDataList) {
    return Future.value([
      charts.Series<Map, String>(
        id: 'Daily Expenses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Map data, _) =>
            DateFormat.yMMMd().parse(data['date']).day.toString(),
        measureFn: (Map data, _) => data['expense'],
        data: chartDataList,
      )
    ]);
  }
}
