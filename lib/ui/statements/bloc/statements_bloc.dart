import 'package:expends/database/data/categories_provider.dart';
import 'package:expends/database/data/expends_provider.dart';

class StatementsBloc {
  var _expendsProvider = ExpendsProvider();
  var _categoryProvider = CategoriesProvider();

  Future<List<dynamic>> getAllMonths() {
    return _expendsProvider.getAllMonths();
  }

  Future<double> getTotalExpenseOfMonth(String month) {
    return _expendsProvider.getTotalExpenseOfMonth(month);
  }
}
