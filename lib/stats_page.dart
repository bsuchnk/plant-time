import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'dart:math';
import 'package:timer_app/chartview.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getListOfSessionInfos(),
      builder: (context, snapshot) {
        return Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: currentStatsDate,
                    firstDate: DateTime.utc(2021, 2, 1),
                    lastDate: DateTime(2031, 12, 31),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        //_data = [];
                        currentStatsDate = value;
                        //_calculateData();
                        //_getListOfSessionInfos();
                      });
                    }
                  });
                },
                child: Text(dayFormat.format(currentStatsDate)),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ChartView(),
                    LogView(),
                    GardenView(),
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
      },
    );
  }

  Future<List<SessionInfo>> _getListOfSessionInfos() async {
    DateFormat cutTo00 = DateFormat('yyyy-MM-dd');
    DateTime date1 = DateTime.parse(cutTo00.format(currentStatsDate));
    //developer.log(date1.toString());
    DateTime date2 = currentStatsDate.add(Duration(days: 1));
    currentSessionInfoList =
        await DatabaseProvider.db.getSessionInfosBetween(date1, date2);
    return currentSessionInfoList;
  }
}

class LogView extends StatefulWidget {
  @override
  _LogViewState createState() => _LogViewState();
}

class _LogViewState extends State<LogView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildSessionInfoDataRows(context),
        ],
      ),
    );
  }
}

//

class GardenView extends StatefulWidget {
  @override
  _GardenViewState createState() => _GardenViewState();
}

class _GardenViewState extends State<GardenView> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      child: _buildGallery(),
    );
  }

  _buildGallery() {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(20),
      children: _buildImageList(),
    );
  }

  _buildImageList() {
    List<Widget> list = [];
    for (int i = 0; i < currentSessionInfoList.length; i++) {
      list.add(
        Stack(
          children: [
            Center(
              child: Image.asset(plantPath(currentSessionInfoList[i].plant, 2)),
            ),
            Image.asset('assets/images/frame.png'),
          ],
        ),
      );
    }
    return list;
  }
}

DataTable _buildSessionInfoDataRows(BuildContext context) {
  List<SessionInfo> list = List.from(currentSessionInfoList);
  list.sort((a, b) => b.date.compareTo(a.date));
  List<DataRow> rows = [];

  for (int i = 0; i < list.length; i++) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(list[i].date);

    rows.add(
      DataRow(
        cells: <DataCell>[
          DataCell(Text(readableDateFormat.format(date))),
          DataCell(Text('${list[i].duration} min')),
          DataCell(Text('${list[i].category}')),
        ],
        color: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return i % 2 == 1 ? null : Colors.yellow.withOpacity(0.25);
        }),
        onSelectChanged: (bool selected) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              //Size screenSize = MediaQuery.of(context).size;
              return SessionInfoCard(list[i]);
            },
          );
        },
      ),
    );
  }

  DataTable table = DataTable(
    showCheckboxColumn: false,
    columns: <DataColumn>[
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Duration')),
      DataColumn(label: Text('Category')),
    ],
    rows: rows,
    sortColumnIndex: 0,
    sortAscending: true,
  );

  return table;
}

class SessionInfoCard extends StatelessWidget {
  final SessionInfo sessionInfo;

  SessionInfoCard(this.sessionInfo);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      content: Container(
        padding: EdgeInsets.all(8),
        height: screenSize.height * 0.5, //TODO: relative size
        child: Column(
          children: [
            Text(
              sessionInfo.category,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    color: Colors.yellow,
                    blurRadius: 2,
                    offset: Offset(2, 1),
                  ),
                ],
              ),
              textScaleFactor: 1.2,
            ),
            Divider(),
            Spacer(flex: 2),
            SizedBox(
              height: screenSize.height * 0.5 * 0.5,
              child: Image.asset(plantPath(sessionInfo.plant, 2)),
            ),
            Spacer(flex: 1),
            RichText(
              text: TextSpan(
                text: 'You focused for ',
                children: [
                  TextSpan(
                    text: '${sessionInfo.duration}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: ' minute${sessionInfo.duration != 1 ? 's' : ''}.'),
                ],
                style: TextStyle(color: Colors.black),
              ),
            ),
            Spacer(flex: 2),
            Divider(),
            Text(readableDateFormat
                .format(DateTime.fromMicrosecondsSinceEpoch(sessionInfo.date))),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreenAccent, Colors.yellowAccent],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
