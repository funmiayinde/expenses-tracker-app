import 'package:expends/database/data/categories.dart';
import 'package:expends/database/data/expends.dart';
import 'package:expends/database/data/expends_model.dart';
import 'package:expends/database/db_helper.dart';

class ExpendsProvider {
  static const String TABLE_NAME = "table_expends";

  Future<Expends> insert(Expends expend) async {
    expend.id = await DBHelper.dbHelper
        .getDatabase()
        .insert(TABLE_NAME, expend.toMap());
    return expend;
  }

  Future<List<Map>> getCategoryWiseExpense(
      String currentMonth, List<Categories> categories) async {
    List<Map> data = [];
    for (var i = 0; i < categories.length; i++) {
      var query =
          "SELECT SUM(expends), COUNT(*), table_categories.id, table_categories.name, table_categories.color, table_categories.icon  FROM " +
              TABLE_NAME +
              " LEFT JOIN table_categories ON table_expends.id_category = table_categories.id" +
              " WHERE id_category='" +
              categories[i].id.toString() +
              "' AND month='" +
              currentMonth +
              "'";

      var res = await DBHelper.dbHelper.getDatabase().rawQuery(query);
      Map map = res.map((c) => c).toList()[0] ?? Map;
      if (map['SUM(expends)'] != null && map['COUNT(*)'] != null) {
        data.add(map);
      }
    }

    return data;
  }

  Future<ExpendsModel> getExpend(int id) async {
    var joinQuery = "SELECT table_expends.*, " +
        "table_categories.name, table_categories.icon, table_categories.color " +
        "FROM table_expends " +
        "LEFT JOIN table_categories ON table_expends.id_category=table_categories.id " +
        "WHERE table_expends.id= '" +
        id.toString() +
        "' ";

    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);
    List<ExpendsModel> maps =
        res.isNotEmpty ? res.map((c) => ExpendsModel.fromMap(c)).toList() : [];

    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  Future<List<Expends>> getExpends() async {
    var res = await DBHelper.dbHelper.getDatabase().query(TABLE_NAME);
    List<Expends> list =
        res.isNotEmpty ? res.map((c) => Expends.fromMap(c)).toList() : [];
    return list;
  }

  Future<double> getTotalExpense() async {
    var joinQuery = "SELECT SUM(expends) FROM " + TABLE_NAME;
    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);

    double expends =
        res.isNotEmpty ? res.map((c) => c["SUM(expends)"]).toList()[0] : 0;

    return expends;
  }

  Future<double> getTotalExpenseOfMonth(String month) async {
    var joinQuery = "SELECT SUM(expends) FROM " +
        TABLE_NAME +
        " WHERE month = '" +
        month +
        "' ";
    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);

    double expends =
        res.isNotEmpty ? res.map((c) => c["SUM(expends)"]).toList()[0] : 0;

    return expends;
  }

  Future<int> getNumberOfExpendOfMonth(String month) async {
    var joinQuery = "SELECT COUNT(*) FROM " +
        TABLE_NAME +
        " WHERE month = '" +
        month +
        "' ";
    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);

    int numberOfExpends =
        res.isNotEmpty ? res.map((c) => c["COUNT(*)"]).toList()[0] : 0;

    return numberOfExpends;
  }

  Future<double> getTotalExpenseOfDate(String date) async {
    var joinQuery = "SELECT SUM(expends) FROM " +
        TABLE_NAME +
        " WHERE date = '" +
        date +
        "' ";
    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);

    double expends =
        res.isNotEmpty ? res.map((c) => c["SUM(expends)"]).toList()[0] : 0;

    return expends;
  }

  Future<List<dynamic>> getAllMonths() async {
    var joinQuery =
        "SELECT DISTINCT month FROM " + TABLE_NAME + " ORDER BY timestamp ASC";

    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);
    List<dynamic> list =
        res.isNotEmpty ? res.map((c) => c["month"]).toList() : [];

    return list;
  }

  Future<List<dynamic>> getAllDates(String month) async {
    var joinQuery = "SELECT DISTINCT date FROM " +
        TABLE_NAME +
        " WHERE month= '" +
        month +
        "' ORDER BY timestamp DESC";

    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);
    List<dynamic> list =
        res.isNotEmpty ? res.map((c) => c["date"]).toList() : [];

    return list;
  }

  Future<List<ExpendsModel>> getExpensesInGroup(String date) async {
    var joinQuery =
        "SELECT table_expends.id, table_expends.date, table_expends.timestamp, table_expends.description, table_expends.expends, table_expends.place, " +
            "table_categories.name, table_categories.icon, table_categories.color " +
            "FROM table_expends " +
            "LEFT JOIN table_categories ON table_expends.id_category=table_categories.id " +
            "WHERE table_expends.date= '" +
            date +
            "' ORDER BY timestamp DESC";

    var res = await DBHelper.dbHelper.getDatabase().rawQuery(joinQuery);
    List<ExpendsModel> list =
        res.isNotEmpty ? res.map((c) => ExpendsModel.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> delete(int id) async {
    return await DBHelper.dbHelper
        .getDatabase()
        .delete(TABLE_NAME, where: '${Expends.columnId} = ?', whereArgs: [id]);
  }

  Future<int> update(Expends expend) async {
    return await DBHelper.dbHelper.getDatabase().update(
        TABLE_NAME, expend.toMap(),
        where: '${Expends.columnId} = ?', whereArgs: [expend.id]);
  }
}
