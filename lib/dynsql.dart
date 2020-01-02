import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _inst;
  DatabaseHelper.internal();
  static DatabaseHelper _inst = DatabaseHelper.internal();
  List<dynamic> tableName = [];
  List<dynamic> tabname = [];
  List<dynamic> tabval = [];
  List<dynamic> tabdata = [];
  List<dynamic> colnameVar = [];
  List<dynamic> colnameConst = [];
  var comma = ',';
  var equal = ' = ';
  String quote = "'";
  var exten = '.db';
  String date, time, concat;
  static Database _dyn;
  int get newVersion => null;

  Future<Database> get dyn async {
    if (_dyn != null) {
      return _dyn;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dbName = prefs.getString('dbName');
    print(dbName);
    return await createDBnxt(dbName);
  }

  Future<Database> createDB(String name) async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, name);

    final dyn = await openDatabase(path, version: 1);
// createTab(dyn, newVersion);
    return dyn;
  }

  Future<Database> createDBnxt(String name) async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, name);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dbPath = prefs.getString('dbPath');
    final dyn = await openDatabase(dbPath, version: 1);
    print(path);
    print(dbPath);
    print(dyn);
    return dyn;
  }

  Future<dynamic> newTable(List tableName, List variables) async {
    int t;
    String tableVar;
    final int num = tableName.length;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dbPath = prefs.getString('dbPath');
    final dyn = await openDatabase(dbPath, version: 1);

    Future createTabVar(Database dyn, int newVersion) async {
      for (int i = 0; i < variables.length; i++) {
        if (variables == null || variables.isEmpty) {
        } else {
          if (i != variables.length - 1) {
            final eye = variables[i] as String;
            colnameVar.add(eye + comma);
          } else if (i == variables.length - 1) {
            final eye = variables[i] as String;
            colnameVar.add(eye);
          }
        }
      }

      final colNameVar = colnameVar.join();
      print(tableName);
      print(colNameVar);
      await dyn.execute(
          'CREATE TABLE $tableVar ($colNameVar,Id INTEGER PRIMARY KEY AUTOINCREMENT)');
      colnameConst = [];
      colnameVar = [];
    }

    Future returnMethod() async {
      for (t = 0; t < num; t++) {
        tableVar = tableName[t] as String;
        createTabVar(dyn, newVersion);
        colnameConst = [];
        colnameVar = [];
      }
    }

    return returnMethod();
  }

  Future<dynamic> deleteTable(List tableName) async {
    int t;
    final int num = tableName.length;
    String tableVar;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dbPath = prefs.getString('dbPath');
    final dyn = await openDatabase(dbPath, version: 1);

    Future delTabVar(Database dyn, int newVersion) async {
      await dyn.execute('DROP TABLE $tableVar');
    }

    Future<dynamic> returnMethod() async {
      for (t = 0; t < num; t++) {
        tableVar = tableName[t] as String;
        delTabVar(dyn, newVersion);
      }
    }

    return returnMethod();
  }

  // INSERT INTO TABLE!
  Future<dynamic> insertTabVal(
      String tableName, List samplesTitle, List samplesValue) async {
    final dyClient = await dyn;
    String tabVal, tabName;
    for (var i = 0; i < samplesTitle.length; i++) {
      if (i != samplesTitle.length - 1) {
        final eye = samplesTitle[i] as String;
        tabname.add(eye + comma);
      } else if (i == samplesTitle.length - 1) {
        final eye = samplesTitle[i] as String;
        tabname.add(eye);
      }
    }
    for (var i = 0; i < samplesValue.length; i++) {
      if (i != samplesValue.length - 1) {
        final eye = samplesValue[i] as String;
        tabval.add(quote + eye + quote + comma);
      } else if (i == samplesValue.length - 1) {
        final eye = samplesValue[i] as String;
        tabval.add(quote + eye + quote);
      }
    }
    tabName = tabname.join();
    tabVal = tabval.join();
    print(tabName);
    print(tabVal);
    tabname = [];
    tabval = [];

    Future resultMethod() async {
      final result = await dyClient.rawInsert('INSERT INTO $tableName($tabName)'
          'VALUES($tabVal)');
      tabname = [];
      tabval = [];
      return result;
    }

    return resultMethod();
  }

  // DELETE FROM TABLE!
  Future<int> deleteTabVal(int id, String tabName) async {
    final dyClient = await dyn;
    return await dyClient.rawDelete('DELETE FROM $tabName WHERE id = $id');
  }

  // UPDATE TABLE VALUES!
  Future<int> updateTabVal(
      List sampleUpdate, List sampleUpdateValue, int id) async {
    final dyClient = await dyn;
    var tabData;
    for (var i = 0; i < sampleUpdate.length; i++) {
      if (i != sampleUpdate.length - 1) {
        tabdata.add(sampleUpdate[i] + equal + sampleUpdateValue[i] + comma);
      } else if (i == sampleUpdate.length - 1) {
        tabdata.add(sampleUpdate[i] + equal + sampleUpdateValue[i]);
      }
    }

    tabData = tabdata.join();
    date = DateTime.now() as String;
    time = TimeOfDay.now() as String;
    concat = sampleUpdate[0] + date + time;
    print(tabData);
    print(date);
    print(time);
    print(concat);
    return await dyClient
        .rawUpdate('UPDATE projects SET $tabData WHERE id = $id');
  }

  // GET ALLFROM TABLE!
  Future<List<Map>> getAllSamples(String tabName) async {
    final dyClient = await dyn;
    final result = await dyClient.rawQuery('SELECT * FROM $tabName');
    print(result.toList());
    return result.toList();
  }

  // GET TABLE STRUCTURE!
  Future<List<Map>> getTableInfo(String tabName) async {
    final dyClient = await dyn;
    final result = await dyClient.rawQuery('PRAGMA table_info($tabName)');
    print(result.toList());
    return result.toList();
  }

  // GET ALL TABLES!
  Future<List<Map>> getAllTables() async {
    final dyClient = await dyn;
    final result = await dyClient.rawQuery('SELECT name FROM sqlite_master '
        'WHERE type == "table" AND name NOT LIKE "sqlite_%" AND name NOT LIKE "android%" AND name NOT LIKE "%_CONST"');
    print(result.toList());
    return result.toList();
  }

  // GET ALL FROM AN ID!
  // Future<List<Map>> getProject(int id) async {
  //   final dyClient = await dyn;
  //   final result =
  //       await dyClient.rawQuery('SELECT * FROM projects WHERE id = $id');

  //   if (result.isNotEmpty) {
  //     return result.toList();
  //   } else {
  //     return null;
  //   }
  // }

  // GET NUMBER OF SAMPLES!
  // Future<int> getCount() async {
  //   final dyClient = await dyn;
  //   return Sqflite.firstIntValue(
  //       await dyClient.rawQuery('SELECT COUNT(*) FROM projects'));
  // }

  //CLOSE DB!
  Future dynamicDBclose() async {
    final dbClient = await dyn;
    return await dbClient.close();
  }
}
