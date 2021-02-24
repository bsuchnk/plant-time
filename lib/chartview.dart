import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:timer_app/constants.dart';

class ChartView extends StatefulWidget {
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<List<SessionInfoSeries>> _data;

  @override
  void initState() {
    super.initState();
    _data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FractionallySizedBox(
            heightFactor: 1,
            child: PlantChar(data: _calculateData()),
          ),
        ),
        //Spacer(),
        CategoriesSummary(data: _calculateData()),
      ],
    );
  }

  List<List<SessionInfoSeries>> _calculateData() {
    _data = [];
    for (int c = 0; c < categories.length; c++) {
      _data.add(List());
      for (int i = 0; i < 24; i++) {
        _data[c].add(SessionInfoSeries(
          hour: i.toString(),
          minutes: 0,
        ));
      }
    }

    //await DatabaseProvider.db.getAllSessionInfos();
    //developer.log(list.toString());
    for (int i = 0; i < currentSessionInfoList.length; i++) {
      DateTime date =
          DateTime.fromMicrosecondsSinceEpoch(currentSessionInfoList[i].date);
      for (int c = 0; c < categories.length; c++) {
        if (categories[c] == currentSessionInfoList[i].category) {
          for (int j = 0; j < 24; j++) {
            if (_data[c][j].hour == date.hour.toString()) {
              _data[c][j].minutes += currentSessionInfoList[i].duration;
            }
          }
        }
      }
    }
    return _data;
  }
}

class SessionInfoSeries {
  final String hour;
  int minutes;

  SessionInfoSeries({
    @required this.hour,
    @required this.minutes,
  });
}

class PlantChar extends StatelessWidget {
  final List<List<SessionInfoSeries>> data;

  PlantChar({@required this.data});

  @override
  Widget build(BuildContext context) {
    var series = _buildSeries();

    return charts.BarChart(
      series,
      animate: true,
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 2.0),
    );
  }

  _buildSeries() {
    List<charts.Series<SessionInfoSeries, String>> se = [];

    for (int c = 0; c < categories.length; c++) {
      se.add(charts.Series<SessionInfoSeries, String>(
        id: categories[c],
        data: data[c],
        domainFn: (SessionInfoSeries series, _) => series.hour,
        measureFn: (SessionInfoSeries series, _) => series.minutes,
        colorFn: (SessionInfoSeries series, _) =>
            charts.ColorUtil.fromDartColor(categoryColors[c]),
      ));
    }

    return se;
  }
}

class CategoriesSummary extends StatelessWidget {
  final List<List<SessionInfoSeries>> data;

  CategoriesSummary({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _buildSummary(),
        runSpacing: -12,
      ),
    );
  }

  _buildSummary() {
    List<Widget> list = [];

    for (int i = 0; i < categories.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Chip(
            label: Text(
              categories[i],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            backgroundColor: categoryColors[i],
            elevation: 2,
          ),
        ),
      );
    }

    return list;
  }
}
