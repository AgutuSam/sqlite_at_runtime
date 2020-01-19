import 'package:flutter/material.dart';

import 'package:sqlite_at_runtime/sqlite_at_runtime.dart';

class Tables extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Tables();
  }
}

class _Tables extends State<Tables> {
  static Future<List<Map>> fetch() async {
    await Sqlartime.openDb('myDeeBee');
    return Sqlartime.getTables();
  }

  createone() {
    Sqlartime.tableCreate(['body'], ['eyes TEXT', 'hearts NUMBER']);
  }

  createtwo() {
    Sqlartime.tableCreate(['time'], ['days TEXT', 'years NUMBER']);
  }

  createthree() {
    Sqlartime.tableCreate(['bio'], ['mend TEXT', 'temp NUMBER']);
  }

  createfour() {
    Sqlartime.tableCreate(['vehicle'], ['carname TEXT', 'model NUMBER']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 250.0,
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
                      'Create Tab1',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      createone();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Create Tab2',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      createtwo();
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      'Create Tab3',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      createthree();
                    },
                    // onPressed:() {},
                  ),
                  RaisedButton(
                    child: Text(
                      'Create Tab4',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                      createfour();
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 400.0,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List<Map>>(
                future: fetch(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Card(
                                    elevation: 10.0,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    child: Row(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 10.0),
                                            margin: EdgeInsets.only(left: 4.0),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1.5,
                                                        color:
                                                            Colors.black26))),
                                            child: CircleAvatar(
                                              child: Text(snapshot.data[index]
                                                      ['name'][0]
                                                  .toUpperCase()
                                                  .toString()),
                                              radius: 14.0,
                                              backgroundColor:
                                                  Colors.blueAccent,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 15.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data[index]['name']
                                                        as String,
                                                    style: TextStyle(
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Container(
                    alignment: AlignmentDirectional.center,
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
