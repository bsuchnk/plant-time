import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_app/sessioninfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

const minDuration = 1;
const maxDuration = 24 * 60;
const List defaultDurations = [10, 15, 30, 45, 60, 90, 180];
List possibleDurations = List.from(defaultDurations);
const List categories = [
  'studying',
  'exercise',
  'books',
  'coding',
  'meditation',
  'art',
  'music',
  'brainstorm',
  'yoga',
];
const List categoryIcons = [
  Icons.school_outlined,
  Icons.fitness_center,
  Icons.menu_book,
  Icons.code,
  Icons.sentiment_very_satisfied_outlined,
  Icons.create_outlined,
  Icons.music_note,
  Icons.wb_incandescent_outlined,
  Icons.self_improvement,
];
const List categoryColors = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.amber,
  Colors.grey,
  Colors.deepOrangeAccent,
  Colors.deepPurpleAccent,
  Colors.brown,
  Colors.tealAccent,
];
List categoryVisibilities = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
];

const List<String> plants = [
  'drzewko',
  'drzewko_bond',
  'karo',
];

int currentPlant = 0;
int currentPlantPhase = 0;
int currentCategory = 0;
int currentDuration = 3;
DateTime currentStatsDate = DateTime.now();
List<SessionInfo> currentSessionInfoList = [];

const Color col_ground = Colors.amber; //Color(0x80DAA520);
const Color col_grass = Color(0xff32cd32);
const Color col_gold = Colors.yellow; //Color(0xFFF0E68C);
const Color col_lg = Colors.lightGreenAccent;

String plantPath(int plant, int phase, {String format = 'png'}) {
  // TEMPORARY
  if (plant == 3) format = 'svg';
  return 'assets/images/' + plants[plant] + phase.toString() + '.' + format;
}

DateFormat dayFormat = DateFormat('dd.MM.yyyy');
DateFormat dayTimeFormat = DateFormat('HH:mm:ss');
DateFormat readableDateFormat = DateFormat('dd.MM.yy, HH:mm:ss');
