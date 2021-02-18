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
