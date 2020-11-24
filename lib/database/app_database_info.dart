import 'package:expends/database/data/categories_provider.dart';
import 'package:expends/database/data/expends_provider.dart';
import 'package:expends/database/db_info.dart';
import 'package:expends/database/imigration_task.dart';
import 'package:expends/database/tables.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabaseInfo implements DBInfo, IMigrationTask {
  static const String DATABASE_NAME = "db_expends.db";
  static const int DATABASE_VERSION = 2;

  @override
  String getDatabaseName() {
    return DATABASE_NAME;
  }

  @override
  int getDatabaseVersion() {
    return DATABASE_VERSION;
  }

  @override
  List<String> getTableCreationQueries() {
    return _generateCreationQueryList();
  }

  @override
  List<String> getTableNameList() {
    List<String> dbTableNameList = [];
    dbTableNameList.add(CategoriesProvider.TABLE_NAME);
    dbTableNameList.add(ExpendsProvider.TABLE_NAME);
    return dbTableNameList;
  }

  @override
  Future<bool> onUpgrade(Database theDb, int oldVersion, int newVersion) async {
    List<String> dbDropList = _generateDropQueryList();
    List<String> dbSchemaQueryList = _generateCreationQueryList();

    for (var i = 0; i < dbDropList.length; i++) {
      theDb.execute(dbDropList[i]);
    }
    print('table deleted');

    for (var i = 0; i < dbSchemaQueryList.length; i++) {
      theDb.execute(dbSchemaQueryList[i]);
    }
    print('new tables created');

    return true;
  }

  List<String> _generateDropQueryList() {
    List<String> dbDropList = [];

    for (var i = 0; i < getTableNameList().length; i++) {
      String query = "DROP TABLE IF EXISTS " + getTableNameList()[i];
      dbDropList.add(query);
    }

    return dbDropList;
  }

  List<String> _generateCreationQueryList() {
    List<String> dbSchemaQueryList = [];
    dbSchemaQueryList.add(Tables.CREATE_TABLE_CATEGORIES);
    dbSchemaQueryList.add(Tables.CREATE_TABLE_EXPENDS);
    return dbSchemaQueryList;
  }

  @override
  IMigrationTask getMigrationTask() {
    return this;
  }
}
