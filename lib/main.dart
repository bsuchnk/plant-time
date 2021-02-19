import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/session.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:timer_app/stats_page.dart';
import 'package:timer_app/my_widgets.dart';
import 'dart:developer' as developer;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _selectedMenu;

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _selectedMenu = 1;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Plant Time',
              textScaleFactor: 2,
              style: TextStyle(color: col_gold),
            ),
          ),
          backgroundColor: col_grass,
          bottom: _selectedMenu == 2
              ? TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.multiline_chart)),
                    Tab(icon: Icon(Icons.list)),
                    Tab(icon: Icon(Icons.brightness_7_outlined)),
                  ],
                )
              : null,
        ),
        body: _selectedMenu == 1
            ? buildHome(size, context)
            : buildStats(size, context),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: 'Stats'),
          ],
          currentIndex: _selectedMenu,
          backgroundColor: col_grass,
          onTap: _onBottomItemTapped,
        ),
      ),
    );
  }

  Container buildHome(Size size, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Spacer(),
          OneOfPlants(
            notifyParent: refresh,
          ),
          Spacer(),
          Container(
            width: size.height * 0.4,
            height: size.height * 0.4,
            child: Image.asset(plantPath(currentPlant, 2)),
          ),
          Spacer(),
          OneOfButtons(),
          Spacer(),
          OneOfCategories(),
          Spacer(),
          Container(
            child: IconButton(
              icon: Icon(Icons.timer),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionPage()),
                  );
                });
              },
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: col_gold,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: Offset(1, 3),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
      decoration: new BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.lightGreenAccent,
          Colors.yellowAccent,
        ]),
      ),
    );
  }

  Container buildStats(Size size, BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              children: [
                ChartView(),
                buildStatsLog(),
                CircularProgressIndicator(),
              ],
            ),
          ),
        ],
      ),
      decoration: new BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.lightGreenAccent,
          Colors.yellowAccent,
        ]),
      ),
    );
  }

  SingleChildScrollView buildStatsLog() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          FutureBuilder(
              future: _buildSessionInfoDataRows(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else {
                  return Column(
                    children: <Widget>[
                      //Spacer(),
                      CircularProgressIndicator(),
                      //Spacer(),
                    ],
                  );
                }
              }),
        ],
      ),
    );
  }

  Future<DataTable> _buildSessionInfoDataRows() async {
    List<SessionInfo> list = await DatabaseProvider.db.getAllSessionInfos();
    List<DataRow> rows = [];

    for (int i = 0; i < list.length; i++) {
      DateTime date = DateTime.fromMicrosecondsSinceEpoch(list[i].date);

      rows.add(DataRow(
        cells: <DataCell>[
          DataCell(Text(date.toString())),
          DataCell(Text('${list[i].duration} min')),
          DataCell(Text('${list[i].category}')),
        ],
      ));
    }

    DataTable table = DataTable(
      columns: <DataColumn>[
        DataColumn(label: Text('date')),
        DataColumn(label: Text('duration')),
        DataColumn(label: Text('category')),
      ],
      rows: rows,
      sortColumnIndex: 0,
      sortAscending: true,
    );

    return table;
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedMenu = index;
    });
  }
}
