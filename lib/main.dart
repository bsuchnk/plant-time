import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer_app/constants.dart';
import 'package:timer_app/session.dart';
import 'package:timer_app/stats_page.dart';
import 'package:timer_app/my_widgets.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Plant Time',
            textScaleFactor: 2,
            style: TextStyle(color: col_gold),
          ),
        ),
        backgroundColor: col_grass,
      ),
      body: Container(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'settings'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'stats'),
        ],
        currentIndex: _selectedMenu,
        backgroundColor: col_grass,
        onTap: _onBottomItemTapped,
      ),
    );
  }

  void _onBottomItemTapped(int index) {
    setState(() {
      _selectedMenu = index;
    });
  }
}
