import 'package:flutter/material.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:graphic/graphic.dart' as graphic;
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

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
  List<Map> _data;
  DateFormat _dayFormat;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
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
                  _calculateData();
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
        SizedBox(
          width: 400,
          height: 400,
          child: FutureBuilder(
            future: _calculateData(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                developer.log(snapshot.data.toString());
                return graphic.Chart(
                  data: snapshot.data,
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
                      // color: graphic.ColorAttr(values: [
                      //   graphic.Defaults.theme.colors.first.withAlpha(80),
                      // ]),
                    ),
                    // graphic.LineGeom(
                    //   position: graphic.PositionAttr(field: 'hour*minutes'),
                    //   shape: graphic.ShapeAttr(
                    //       values: [graphic.BasicLineShape(smooth: true)]),
                    //   size: graphic.SizeAttr(values: [0.5]),
                    // ),
                  ],
                  axes: {
                    'hour': graphic.Defaults.horizontalAxis,
                    'minutes': graphic.Defaults.verticalAxis,
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<List<Map>> _calculateData() async {
    _data = [];
    for (int i = 0; i < 24; i++) {
      _data.add({'hour': i.toString(), 'minutes': 0});
    }

    DateFormat cutTo00 = DateFormat('yyyy-MM-dd');
    DateTime date1 = DateTime.parse(cutTo00.format(_dateTime));
    //developer.log(date1.toString());
    DateTime date2 = _dateTime.add(Duration(days: 1));
    List<SessionInfo> list =
        await DatabaseProvider.db.getSessionInfosBetween(date1, date2);
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
}
