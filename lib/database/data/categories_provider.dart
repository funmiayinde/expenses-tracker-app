import 'package:expends/database/data/categories.dart';
import 'package:expends/database/db_helper.dart';

class CategoriesProvider {
  static const String TABLE_NAME = "table_categories";

  Future<Categories> insert(Categories category) async {
    category.id = await DBHelper.dbHelper
        .getDatabase()
        .insert(TABLE_NAME, category.toMap());
    return category;
  }

  Future<Categories> getCategory(int id) async {
    List<Map> maps = await DBHelper.dbHelper.getDatabase().query(TABLE_NAME,
        columns: [
          Categories.columnId,
          Categories.columnName,
          Categories.columnColor,
          Categories.columnIcon
        ],
        where: '${Categories.columnId} = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Categories.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Categories>> getCategories() async {
    var res = await DBHelper.dbHelper.getDatabase().query(TABLE_NAME);
    List<Categories> list =
        res.isNotEmpty ? res.map((c) => Categories.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> delete(int id) async {
    return await DBHelper.dbHelper.getDatabase().delete(TABLE_NAME,
        where: '${Categories.columnId} = ?', whereArgs: [id]);
  }

  Future<int> update(Categories category) async {
    return await DBHelper.dbHelper.getDatabase().update(
        TABLE_NAME, category.toMap(),
        where: '${Categories.columnId} = ?', whereArgs: [category.id]);
  }
}
