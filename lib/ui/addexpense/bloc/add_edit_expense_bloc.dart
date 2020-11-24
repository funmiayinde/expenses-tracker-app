import 'package:expends/database/data/expends.dart';
import 'package:expends/database/data/expends_model.dart';
import 'package:expends/database/data/expends_provider.dart';

class AddEditExpenseBloc {
  var _provider = ExpendsProvider();

  Future<Expends> insertExpense(Expends expend) {
    return _provider.insert(expend);
  }

  Future<ExpendsModel> getExpense(int expenseId) {
    return _provider.getExpend(expenseId);
  }

  Future<int> deleteExpense(int expenseId) {
    return _provider.delete(expenseId);
  }

  Future<int> updateExpense(Expends expend) {
    return _provider.update(expend);
  }
}
