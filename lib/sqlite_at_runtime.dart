library sqlite_at_runtime;

import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqlite_at_runtime/dbhelper.dart' as stat;
import 'package:sqlite_at_runtime/dynsql.dart' as flex;

class Sqlartime {
  static String exten = '.db';
  static final dy = flex.DatabaseHelper();
  static final db = stat.DatabaseHelper();
  String quote = '"';
  String quest = '?';

//CREATE NEW DB
   static Future<dynamic> addNewDB(String name, String note) async {
    return await db.newDB([name, note]);
  }

//GET LIST OF ALL DBs
   static Future<List<Map>> fetchDBs() async {
    return db.getAllDB();
  }

//DELETE/DROP EXISTING DB
  static Future<dynamic> deleteDb(int id, String dbName) async {
    await openDb(dbName);
    return await db.dropDB(id, dbName);
  }

//OPEN EXISTING DB
  static openDb(String dbName) async {
    await closeMain();
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, dbName + exten);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dbName', dbName);
    prefs.setString('dbPath', path);
    final currentDB = await openDatabase(dbName + exten);
    print(currentDB);
    print(path);
    return currentDB;
  }
//CLOSE AN OPEN DATABASE
static closeDyn() async {
    await dy.dynamicDBclose();
  }

//ADD TABLE(S) TO EXISTING DB
  static Future<dynamic> tableCreate(List tableName, List variables) async {
    return await dy.newTable(tableName, variables);
  }

//DELETE/DROP TABLE FROM EXISTING DB
  static Future<dynamic> deleteTable(List tabName) async {
    return await dy.deleteTable(tabName);
  }

//GET ALL TABLES FROM EXISTING DB
  static Future<List<Map>> getTables() async {
    return await dy.getAllTables();
  }

//INSERT INTO TABLE
  static Future<dynamic> insertIntoTable(
      String tableName, List columnTitle, List samplesValue) async {
    return await dy.insertTabVal(tableName, columnTitle, samplesValue);
  }

//DELETE FROM TABLE
  static  Future<int> deleteTableValues(int id, String tabName) async {
    return await dy.deleteTabVal(id, tabName);
  }

// UPDATE TABLE VALUES
  static Future<int> updateTableValues(
      List sampleUpdate, List sampleUpdateValue, int id) async {
    return await dy.updateTabVal(sampleUpdate, sampleUpdateValue, id);
  }

//GET ALL FROM TABLE
  static Future<dynamic> getAll(String tabName) async {
    return await dy.getAllSamples(tabName);
  }

/* 
FOR THE FUTURE
--Update table values
--Get table specific table values
--Get table values by specific table entity
--Delete specific from table
*/

 static Future<dynamic> closeMain() async {
    await db.defaultDBclose();
  }
  
}
