import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import 'dart:math';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Text("Stats"),
            FutureBuilder(builder: (
              BuildContext context,
              AsyncSnapshot<List<SessionInfo>> snapshot,
            ) {
              return Center(child: CircularProgressIndicator());
            }),
          ],
        ),
      ),
    );
  }
}

class ChartView extends StatefulWidget {
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  DateTime _dateTime;
  List<SessionInfo> _list;
  List<Map> _data;
  DateFormat _dayFormat;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _list = [];
    _data = [];
    _dayFormat = DateFormat('dd.MM.yyyy');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _dateTime,
              firstDate: DateTime.utc(2021, 2, 1),
              lastDate: DateTime(2031, 12, 31),
            ).then((value) {
              if (value != null) {
                setState(() {
                  _data = [];
                  _dateTime = value;
                  _calculateData(_list);
                });
              }
            });
          },
          child: Text('date'),
        ),
        Text(
          _dayFormat.format(_dateTime),
          textScaleFactor: 2,
        ),
        FutureBuilder(
          future: _getListOfSessionInfos(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              //developer.log(snapshot.data.toString());
              return Column(
                children: [
                  SizedBox(
                    width: 400,
                    height: 200,
                    child: graphic.Chart(
                      data: _calculateData(snapshot.data),
                      scales: {
                        'hour': graphic.CatScale(
                          accessor: (map) => map['hour'] as String,
                        ),
                        'minutes': graphic.LinearScale(
                          accessor: (map) => map['minutes'] as num,
                          nice: true,
                        )
                      },
                      geoms: [
                        graphic.IntervalGeom(
                          position: graphic.PositionAttr(field: 'hour*minutes'),
                          shape: graphic.ShapeAttr(values: [
                            graphic.RectShape(radius: Radius.circular(5))
                          ]),
                        ),
                      ],
                      axes: {
                        'hour': graphic.Defaults.horizontalAxis,
                        'minutes': graphic.Defaults.verticalAxis,
                      },
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    height: 200,
                    child: Stack(
                      children: _buildGarden(snapshot.data),
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }

  Future<List<SessionInfo>> _getListOfSessionInfos() async {
    DateFormat cutTo00 = DateFormat('yyyy-MM-dd');
    DateTime date1 = DateTime.parse(cutTo00.format(_dateTime));
    //developer.log(date1.toString());
    DateTime date2 = _dateTime.add(Duration(days: 1));
    _list = await DatabaseProvider.db.getSessionInfosBetween(date1, date2);
    return _list;
  }

  List<Map> _calculateData(List<SessionInfo> list) {
    _data = [];
    for (int i = 0; i < 24; i++) {
      _data.add({'hour': i.toString(), 'minutes': 0});
    }

    //await DatabaseProvider.db.getAllSessionInfos();
    //developer.log(list.toString());
    for (int i = 0; i < list.length; i++) {
      DateTime date = DateTime.fromMicrosecondsSinceEpoch(list[i].date);
      for (int j = 0; j < 24; j++) {
        if (_data[j]['hour'] == date.hour.toString()) {
          _data[j]['minutes'] += list[i].duration;
        }
      }
    }
    return _data;
  }

  _buildGarden(List<SessionInfo> data) {
    List<Widget> list = [];
    for (int i = 0; i < data.length; i++) {
      list.add(Positioned(
        top: Random().nextInt(200 - 64).toDouble(),
        left: Random().nextInt(400 - 64).toDouble(),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Image.asset(plantPath(data[i].plant, 2)),
        ),
      ));
    }
    return list;
  }
}

class GardenView extends StatefulWidget {
  @override
  _GardenViewState createState() => _GardenViewState();
}

class _GardenViewState extends State<GardenView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: _buildGarden(),
      ),
    );
  }

  _buildGarden() {
    List<Widget> list = [];

    return list;
  }
}
