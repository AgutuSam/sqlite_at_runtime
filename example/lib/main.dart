import 'package:example/tables.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runtime_SQLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  create() {
    return Sqlartime.addNewDB('myDeeBee', 'optional');
  }

  delete() {
    return Sqlartime.deleteDb(1, 'myDeeBee');
  }

  static Future<List<Map>> fetch() {
    return Sqlartime.fetchDBs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: 400.0,
          width: MediaQuery.of(context).size.width,
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 2.0,
            padding: const EdgeInsets.all(8.0),
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            children: <Widget>[
              RaisedButton(
                child: Text(
                  'Create DB',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: create,
              ),
              RaisedButton(
                child: Text(
                  'Drop DB',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: delete,
              ),
              RaisedButton(
                child: Text(
                  'DB Detail',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () => fetch().then((value) {
                  Toast.show(value.toString(), context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }),
                // onPressed:() {},
              ),
              RaisedButton(
                child: Text(
                  'Tables',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Tables()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
