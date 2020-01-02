import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_at_runtime/dynsql.dart' as flex;

class DatabaseHelper {
  factory DatabaseHelper() => _instance;
  DatabaseHelper.internal();
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  final daync = flex.DatabaseHelper();
  static Database _db;
  List<dynamic> tabname = [];
  List<dynamic> tabval = [];
  List<dynamic> tabdata = [];
  var comma = ',';
  var equal = ' = ';
  String quote = '"';
  final String exten = '.db';
  var date, time, concat;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    return await initDb();
  }

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'defaultDB.db');
    final db = await openDatabase(path, version: 1, onCreate: _onCreate);
    final result = await db.rawQuery('SELECT name FROM sqlite_master '
        'WHERE type == "table" AND name NOT LIKE "sqlite_%" AND name NOT LIKE "android%"');
    print(result.toList());
    print(db);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE defaultDB (Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,note TEXT,time TEXT)');
  }

  // ADD NEW DATABASE!
  Future<dynamic> newDB(List entity) async {
    final dbClient = await db;
    var tabName;
    for (var i = 0; i < entity.length; i++) {
      if (i != entity.length - 1) {
        final eye = entity[i] as String;
        tabname.add(quote + eye + quote + comma);
      } else if (i == entity.length - 1) {
        final eye = entity[i] as String;
        tabname.add(quote + eye + quote);
      }
    }

    tabName = tabname.join();
    final DateTime today = DateTime.now();
    final String nameTime =
        "$quote${entity[0]}${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}${today.hour.toString().padLeft(2, '0')}${today.minute.toString().padLeft(2, '0')}$quote";
    print(tabName);
    final result =
        await dbClient.rawInsert('INSERT INTO defaultDB(name,note,time)'
            'VALUES($tabName,$nameTime)');
    tabName = [];
    print(result);
    daync.createDB(nameTime);
    return result;
  }

  // DROP A DATABASE!
  Future<dynamic> dropDB(int id, String name) async {
    final dbClient = await db;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dbPath = prefs.getString('dbPath');
    final dir = Directory(dbPath);
    print(id);
    print(name);
    final bool exist = await databaseExists(dbPath);
    print(exist);
    await dbClient.rawDelete('DELETE FROM defaultDB WHERE Id = $id');
    dir.deleteSync(recursive: true);
    await deleteDatabase(dbPath);
    print(exist);
  }

// // UPDATE TABLE VALUES!
//   Future<int> updateDB(Psample sample,int id) async {
//     final dbClient = await db;

// var tabData;

// for (var i = 0; i < sample.samplesTitle.length; i++)  {
//    if(i != sample.samplesTitle.length-1){
//        tabdata.add(sample.samplesTitle[i]+equal+sample.samplesValue[i]+comma);
//      }else if(i == sample.samplesTitle.length-1){
//     tabdata.add(sample.samplesTitle[i]+equal+sample.samplesValue[i]);
//     }
// }

// tabData = tabdata.join();
// date = DateTime.now() as String;
// time = TimeOfDay.now() as String;
// concat = entity[0]+date+time;
// print(tabData);
// print(date);
// print(time);
// print(concat);
//     // return await dbClient.update(tableName, sample.toMap(), where: "$columnId = ?", whereArgs: [sample.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE defaultDB SET $tabData WHERE id = $id');
//   }

// GET ALL ON DATABASES!
  Future<List<Map>> getAllDB() async {
    final dbClient = await db;
    final result = await dbClient.rawQuery('SELECT * FROM defaultDB');
    print(result.toList());
    return result.toList();
  }

  // GET ALL ON DATABASES BY ID!
  Future<List<Map>> getByID(int id) async {
    final dbClient = await db;
    final result =
        await dbClient.rawQuery('SELECT * FROM defaultDB WHERE Id = $id');
    if (result.isNotEmpty) {
      print(result.toList());
      return result.toList();
    } else {
      return null;
    }
  }

  // GET NUMBER OF defaultDB!
  Future<int> getDBCount() async {
    final dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM defaultDB'));
  }

  Future defaultDBclose() async {
    final dbClient = await db;
    return await dbClient.close();
  }
}
