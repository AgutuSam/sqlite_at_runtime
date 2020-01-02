library sqlite_at_runtime;

import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqlite_at_runtime/dbhelper.dart' as stat;
import 'package:sqlite_at_runtime/dynsql.dart' as flex;

class Dynamic {
  static String exten = '.db';
  final dy = flex.DatabaseHelper();
  final db = stat.DatabaseHelper();
  String quote = '"';
  String quest = '?';

//CREATE NEW DB
  Future addNewDB(String name, String note) async {
    return await db.newDB([name, note]);
  }

//GET LIST OF ALL DBs
  Future<List<Map>> fetchDBs() async {
    return db.getAllDB();
  }

//DELETE/DROP EXISTING DB
  Future deleteDb(int id, String dbName) async {
    return await db.dropDB(id, dbName);
  }

//OPEN EXISTING DB
  Future openDb(String dbName) async {
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
Future closeDyn() async {
    await dy.dynamicDBclose();
  }

//ADD TABLE(S) TO EXISTING DB
  Future tableCreate(List tableName, List variables) async {
    return await dy.newTable(tableName, variables);
  }

//DELETE/DROP TABLE FROM EXISTING DB
  Future deleteTable(int id, String tabName) async {
    return await dy.deleteTabVal(id, tabName);
  }

//GET ALL TABLES FROM EXISTING DB
  Future getTables() async {
    return await dy.getAllTables();
  }

//INSERT INTO TABLE
  Future insertIntoTable(
      String tableName, List columnTitle, List samplesValue) async {
    return await dy.insertTabVal(tableName, columnTitle, samplesValue);
  }

//DELETE FROM TABLE
  Future deleteTableValues(int id, String tabName) async {
    dy.deleteTabVal(id, tabName);
  }

// UPDATE TABLE VALUES
  Future updateTableValues(
      List sampleUpdate, List sampleUpdateValue, int id) async {
    dy.updateTabVal(sampleUpdate, sampleUpdateValue, id);
  }

//GET ALL FROM TABLE
  Future getAll(String tabName) async {
    return await dy.getAllSamples(tabName);
  }

/* 
FOR THE FUTURE
--Update table values
--Get table specific table values
--Get table values by specific table entity
--Delete specific from table
*/

  Future closeMain() async {
    await db.defaultDBclose();
  }
  
}
