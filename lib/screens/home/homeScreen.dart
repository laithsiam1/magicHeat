import 'package:flutter/material.dart';
import 'package:magic_heat/services/authentication.dart';
import 'package:magic_heat/utilities/showCustomDialog.dart';
import 'package:http/http.dart' as http;

import './dataCellWidget.dart';

class HomeScreen extends StatefulWidget {
  static const String routePath = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Size _size;
  String _status;
  bool inProgress;

  @override
  void initState() {
    super.initState();
    inProgress = false;
    _status = 'Off';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size;
  }

  void _turnHeatingOn() async {
    setState(() {
      inProgress = true;
    });

    String url = 'http://192.168.1.102:5000/on';

    await http.get(
      Uri.parse(url),
      // body: json.encode({
      //   'op': _status == 'On' ? 'off' : 'on',
      // }),
    );

    setState(() {
      _status = 'On';
      inProgress = false;
    });
  }

  void _turnHeatingOff() async {
    setState(() {
      inProgress = true;
    });

    String url = 'http://192.168.1.102:5000/off';

    await http.get(
      Uri.parse(url),
      // body: json.encode({
      //   'op': _status == 'On' ? 'off' : 'on',
      // }),
    );

    setState(() {
      _status = 'Off';
      inProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Magic Heat',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCustomDialog(
                context,
                title: '',
                content: Container(
                  height: kToolbarHeight,
                  width: 200,
                  child: CircularProgressIndicator(),
                ),
                actions: null,
              );

              Authentication.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Card(
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(
              maxWidth: _size.width * 0.6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Services Building',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(),
                DataTable(
                  headingTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  columns: [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'variable',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'value',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        customDataCell('status'),
                        customDataCell(_status),
                      ],
                    ),
                    DataRow(
                      cells: [
                        customDataCell('Max heat'),
                        customDataCell('24'),
                      ],
                    ),
                    DataRow(
                      cells: [
                        customDataCell('Last user'),
                        customDataCell('Laith Siam'),
                      ],
                    ),
                  ],
                ),
                Divider(),
                ElevatedButton(
                  onPressed: _turnHeatingOn,
                  child: Text('Turn On'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: _turnHeatingOff,
                  child: Text('Turn Off'),
                ),
                Container(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: inProgress ? CircularProgressIndicator() : SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
