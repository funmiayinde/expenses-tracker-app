import 'dart:collection';

import 'package:intl/intl.dart';

import '../../../database/data/categories.dart';
import '../../../database/data/categories_provider.dart';
import '../../../database/data/expends_provider.dart';

class DashboardBloc {
  /// To get current month
  String currentMonth = DateFormat.yMMM().format(DateTime.now().toLocal());

  var _expendsProvider = ExpendsProvider();
  var _categoryProvider = CategoriesProvider();

  Future<double> getTotalExpense() {
    return _expendsProvider.getTotalExpense();
  }

  Future<double> getTotalExpenseOfMonth({String month}) {
    return _expendsProvider.getTotalExpenseOfMonth(month ?? currentMonth);
  }

  Future<List<Categories>> getCategories() {
    return _categoryProvider.getCategories();
  }

  Future<List<dynamic>> getCategoryWiseExpense({String month}) async {
    var categories = await getCategories();
    var data = await _expendsProvider.getCategoryWiseExpense(
        month ?? currentMonth, categories);

    List<Map> chartDataList = [];

    for (var i = 0; i < data.length; i++) {
      Map<String, dynamic> map = new HashMap();
      map['expend'] = data[i]['SUM(expends)'].toString();
      map['transaction'] = data[i]['COUNT(*)'].toString();
      map['category'] = Categories(
          id: data[i]['id'],
          name: data[i]['name'],
          color: data[i]['color'],
          icon: data[i]['icon']);

      chartDataList.add(map);
    }

    return chartDataList;
  }
}
