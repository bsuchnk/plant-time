import 'package:flutter/material.dart';

var whiteShadows = [
  Shadow(
    color: Colors.white,
    offset: Offset(1, 1),
    blurRadius: 3,
  )
];

ThemeData buildThemeData(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.amber, //Colors.yellow,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    // primaryColor: Colors.red,
    // indicatorColor: Colors.red,
    // cardColor: Colors.red,
    // buttonColor: Colors.red,

    textTheme: TextTheme(
      //caption: TextStyle(color: Colors.red),
      button: TextStyle(
        //fontWeight: FontWeight.w500,
        shadows: whiteShadows,
      ),
    ),

    chipTheme: ChipTheme.of(context).copyWith(
      labelStyle: TextStyle(
        color: Colors.black,
        shadows: whiteShadows,
      ),
      secondaryLabelStyle: TextStyle(
        color: Colors.black,
        //fontWeight: FontWeight.w500,
        shadows: whiteShadows,
      ),
    ),
  );
}
