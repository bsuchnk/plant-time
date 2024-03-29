import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:timer_app/database.dart';
import 'dart:developer' as developer;
import 'dart:core';
import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class SessionPage extends StatefulWidget {
  @override
  _SessionPageState createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  bool _loading;
  int _progressValue;
  int _duration;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _progressValue = 0;
    _duration = possibleDurations[currentDuration] * 60;

    currentPlantPhase = 0;

    _updateProgress();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        alignment: Alignment.center,
        //child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(flex: 2),
            Text('${(_progressValue / _duration * 100).round()}%',
                textScaleFactor: 1.5),
            SizedBox(height: 10),
            Stack(
              children: <Widget>[
                Container(
                  width: size.height * 0.4,
                  height: size.height * 0.4,
                  child: Stack(
                    children: [
                      Hero(
                        tag: 'backgroundHero',
                        child: Image.asset('assets/images/background0.png'),
                      ),
                      Hero(
                        tag: 'plantHero',
                        child: FittedBox(
                          child: Image.asset(
                            plantPath(currentPlant, currentPlantPhase),
                            gaplessPlayback: true,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                      Hero(
                        tag: 'frameHero',
                        child: Image.asset('assets/images/frame.png'),
                      ),
                    ],
                    fit: StackFit.expand,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(_calculateTime(_progressValue, _duration),
                textScaleFactor: 1.5),
            Spacer(),
            Container(
              child: IconButton(
                icon: Icon(
                  _loading ? Icons.close_sharp : Icons.check,
                  color: _loading ? Colors.red : Colors.green,
                  size: 32,
                ),
                onPressed: () {
                  _loading = false;
                  Navigator.pop(context);
                },
                padding: EdgeInsets.zero,
              ),
              //color: Colors.white,
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
      ),
      backgroundColor: Colors.pink,
    );
  }

  String _calculateTime(int prog, int dur) {
    int time = dur - prog;
    String res = '';
    var f = new NumberFormat("00", "en_US");

    if (time >= 60 * 60) {
      res += f.format((time / 3600).floor());
      res += ':';
      time = time % 3600;
    }

    res += f.format((time / 60).floor());
    res += ':';
    time = time % 60;

    res += f.format(time);

    return res;
  }

  void _updateProgress() {
    const duration = Duration(seconds: 1);

    new Timer.periodic(duration, (Timer t) {
      if (_loading == false) {
        t.cancel();
        return;
      }

      setState(() {
        _progressValue += 1;
        if (_progressValue >= _duration) {
          _progressValue = _duration;
          _loading = false;
          t.cancel();

          SessionInfo sessionInfo = SessionInfo(
            date: DateTime.now().microsecondsSinceEpoch,
            duration: possibleDurations[currentDuration],
            category: categories[currentCategory],
            plant: currentPlant,
          );

          DatabaseProvider.db.addSessionInfoToDatabase(sessionInfo);
          _sessionEndNotification();

          return;
        }
        currentPlantPhase = (_progressValue / _duration * 3).floor();
      });
    });
  }

  _sessionEndNotification() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate();
    }
    AudioCache audioCache = AudioCache();
    //AudioPlayer audioPlayer = AudioPlayer();
    //AudioPlayer.logEnabled = true;
    await audioCache.play('sounds/bipbop1.wav');
  }
}
