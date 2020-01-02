# sqlite_at_runtime

<!-- [![pub package](https://img.shields.io/pub/v/sqflite.svg)](https://pub.dev/packages/sqflite)
[![git hub](https://travis-ci.org/tekartik/sqflite.svg?branch=master)](https://travis-ci.org/tekartik/sqflite) -->


SQLite plugin for [Flutter](https://flutter.io).
Supports both iOS and Android.

* Allows creation of multiple SQLite databases and their manipulation thus, at application runtime.
* Supports transactions and batches
* Helpers for insert/query/update/delete queries

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
  ...
  sqlite_at_runtime: ^0.0.1
```

For help getting started with Flutter, view the online
[documentation](https://flutter.io/).

## Usage example

Import `sqlite_at_runtime.dart`

```dart
import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';
```

### Databases (create, delete and existence)

Once an application is set up, a default SQLite Database is created, with a table that holds information to the Databases created at runtime.
The major infomation stored here is an id (as the primary key, an auto incremental  integer), the database name and an optional note for the database. 
```dart
// CREATE A NEW DATABASE
await addNewDB(String name, String note);

//GET A LIST OF ALL EXISTING DATABASES
 await fetchDBs(); 

 /* this returns the name, Id and note of the existing databases
in json. To get any of these entities thus:*/
var list = await fetchDBs(); 
//get id
final id = list[index]['Id'];
//get DB name
final id = list[index]['name'];
//get note
final id = list[index]['note'];

//DELETE/DROP AN EXISTING DATABASE
  await deleteDb(int id, String dbName); 

/*A SQLite database is a file in the file system identified by a path. If relative, this path is relative to the path obtained by `getDatabasesPath()`, which is the default database directory on Android and the documents directory on iOS.
The deleteDB() method deletes the database details as stored in the default database, thus the importance to access and provide the database id (from the fetchDBs() method).
The method goes on to delete the file of the named database from the default file directory that holds the database*/

```

<!-- * See [more information on opening a database](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md). -->


### SQL queries
    
Demo code to perform SQL queries
It is important to point out that all SQL queries should be done on an open database;
making the method of opening a given database a rather important one before the entire
lifespan of the database CRUD queries! 

```dart
//OPEN AN EXISTING DB
//the method closes the default database before opening the prescribed runtime created database
await openDb(String dbName);
  
//ADD TABLE(S) TO EXISTING DB
await tableCreate(List tableName, List variables);

/*
The above method take two lists; 
1. A list of tables that come out to share the same structure; this list could without doubt consist of only one table
2. the table structure; with a column name and type in caps, seperated by space.

The below example creates three tables spf the same structures, with a 'name' column of type 'String', 
an 'age' column of type 'int' and a 'temp' column that takes in floating points.

example:
*/
await tableCreate(['sample1','sample2','sample3'],['name TEXT','age INTEGER','temp REAL']);

// a default 'Id INTEGER PRIMARY KEY AUTOINCREMENT' column is created in this process.

<!-- //DELETE/DROP TABLE FROM EXISTING DB
await deleteTable(int id, String tabName); -->

//GET ALL TABLES FROM EXISTING DB
await getTables();

//INSERT INTO TABLE
    //to insert into a table, provide all of three:
    //1. the table name
    //2. a list of the column names to be inserted into
    //3. a list of values that fall respective to the column names provided in #2
await insertIntoTable(String tableName, List columnTitle, List samplesValue);

//GET ALL FROM TABLE
//this returns a list of all table entities, including id(s)
await getAll(String tabName);

//DELETE FROM TABLE
//this method takes in the table name and the entity id and goes on to delete everything with the 
//specified id
//this makes the above method of getting table items a prudent method before the delete method
await deleteTableValues(int id, String tabName);

// UPDATE TABLE VALUES
//muchlike the insert method, the update method takes a list of columns to be manipulated and a list of 
//values for this manipulation
//finally, it takes the id of the entity to be manipulated
await updateTableValues(List sampleUpdate, List sampleUpdateValue, int id);

//CLOSE AN OPEN DATABASE/
//it is important to close a database once the lifespan of all methods realted to it are done!
await closeDyn();
```

<!-- Basic information on SQL [here](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/sql.md). -->



### Batch support

One can use `Batch` as an approach to avoid ping-pong between dart and native code, 

```dart
batch = db.batch();
batch.insert('myTable', {'name': 'sample'});
batch.update('myTable', {'name': 'new_sample'}, where: 'name = ?', whereArgs: ['sample']);
batch.delete('myTable', where: 'name = ?', whereArgs: ['sample']);
results = await batch.commit();
```

Getting the result for each operation has a cost (id for insertion and number of changes for
update and delete), especially on Android where an extra SQL request is executed.
If you don't care about the result and worry about performance in big batches, you can use

```dart
await batch.commit(noResult: true);
```

Warning, during a transaction, the batch won't be committed until the transaction is committed

```dart
await database.transaction((txn) async {
  var batch = txn.batch();
  
  // ...
  
  // commit but the actual commit will happen when the transaction is committed
  // however the data is available in this transaction
  await batch.commit();
  
  //  ...
});
```

By default a batch stops as soon as it encounters an error (which typically reverts the uncommitted changes). You 
can ignore errors so that every successfull operation is ran and committed even if one operation fails:

```dart
await batch.commit(continueOnError: true);
```

## Database, Table and Column names

In general it is better to avoid using SQLite keywords for entity names. If any of the following
name is used:

    "add","all","alter","and","as","autoincrement","between","case","check","collate","commit",
    "isnull","join","limit","not","notnull","null","on","or","order","primary","references","select","constraint","create","default","deferrable","delete","distinct","drop","else","escape","except","exists","foreign","from","group","having","if","in","index","insert","intersect","into","is","set","table","then","to","transaction","union","unique","update","using","values","when","where"
    
the helper will *escape* the name i.e.

```dart
db.query('table')
```
will be equivalent to manually adding double-quote around the table name (confusingly here named `table`)

```dart
db.rawQuery('SELECT * FROM "table"');
```
in addition to these, it is advisable to not use the following names for creating databases:
    "defaultDB" : this happens to be the name of the default database holding infomation on created databases.
    Any other name that has already been used to create an existing database.

However in any other raw statement (including `orderBy`, `where`, `groupBy`), make sure to escape the name
properly using double quote. For example see below where the column name `group` is not escaped in the columns
argument, but is escaped in the `where` argument.

```dart
db.query('table', columns: ['group'], where: '"group" = ?', whereArgs: ['my_group']);
```

## Supported SQLite types

No validity check is done on values yet so please avoid non supported types [https://www.sqlite.org/datatype3.html](https://www.sqlite.org/datatype3.html)


### INTEGER

* Dart type: `int`
* Supported values: from -2^63 to 2^63 - 1

### REAL

* Dart type: `num`

### TEXT

* Dart type: `String`

### BLOB

* Dart type: `Uint8List`
* Dart type `List<int>` is supported but not recommended (slow conversion)

## Current issues

* Due to the way transaction works in SQLite (threads), concurrent read and write transaction are not supported. 
All calls are currently synchronized and transactions block are exclusive. I thought that a basic way to support 
concurrent access is to open a database multiple times but it only works on iOS as Android reuses the same database object.
I also thought a native thread could be a potential future solution however on android accessing the database in another
thread is blocked while in a transaction...
* Currently INTEGER are limited to -2^63 to 2^63 - 1 (although Android supports bigger ones)

## More

<!-- * [How to](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/how_to.md) guide -->
"# sqlite_at_runtime" 
"# sqlite_at_runtime" 
# sqlite_at_runtime
# sqlite_at_runtime
