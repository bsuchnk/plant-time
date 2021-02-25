import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/database.dart';
import 'package:timer_app/session.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:timer_app/stats_page.dart';
import 'package:timer_app/my_widgets.dart';
import 'dart:developer' as developer;
import 'package:timer_app/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:timer_app/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildThemeData(context),
      home: FutureBuilder(
          future: _loadPrefs(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyPage();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  _loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < possibleDurations.length; i++) {
      possibleDurations[i] =
          (prefs.getInt('possibleDurations' + i.toString()) ??
              possibleDurations[i]);
    }
    for (int i = 0; i < categoryVisibilities.length; i++) {
      categoryVisibilities[i] =
          (prefs.getBool('categoryVisibilities' + i.toString()) ??
              categoryVisibilities[i]);
    }

    return true;
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
      initialIndex: 1,
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
                  labelColor: Colors.yellow,
                  unselectedLabelColor: Colors.black,
                )
              : null,
        ),
        body: _selectedMenu == 1
            ? buildHome(size, context)
            : _selectedMenu == 2
                ? StatsPage() //buildStats(size, context)
                : SettingsPage(),
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
            width: size.height * 0.3,
            height: size.height * 0.3,
            child: Stack(
              children: [
                Hero(
                  tag: 'backgroundHero',
                  child: Image.asset(
                    'assets/images/background0.png',
                    gaplessPlayback: true,
                  ),
                ),
                Hero(
                  tag: 'plantHero',
                  child: FittedBox(
                    child: Image.asset(plantPath(currentPlant, 0)),
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

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedMenu = index;
    });
  }
}
