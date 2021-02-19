import 'package:flutter/material.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/sessioninfo.dart';

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

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.utc(2021, 2, 1),
              lastDate: DateTime(2031, 12, 31),
            ).then((value) {
              setState(() {
                _dateTime = value;
              });
            });
          },
          child: Text('date'),
        ),
        Text(
          _dateTime.toString(),
          textScaleFactor: 2,
        ),
      ],
    );
  }
}
