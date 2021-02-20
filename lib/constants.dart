import 'package:flutter/material.dart';

const List possibleDurations = [5, 15, 30, 45, 60, 90, 180];
const List categories = [
  'studying',
  'exercise',
  'books',
  'coding',
  'meditation',
];
const List categoryIcons = [
  Icons.fitness_center,
  Icons.school_outlined,
  Icons.menu_book,
  Icons.code,
  Icons.sentiment_very_satisfied_outlined,
];

const List<String> plants = [
  'drzewko',
  'drzewko_bond',
  'karo',
];

int currentPlant = 0;
int currentPlantPhase = 0;
int currentCategory = 0;
int currentDuration = 10;

const Color col_ground = Colors.amber; //Color(0x80DAA520);
const Color col_grass = Color(0xff32cd32);
const Color col_gold = Colors.yellow; //Color(0xFFF0E68C);

String plantPath(int plant, int phase) {
  return 'assets/images/' + plants[plant] + phase.toString() + '.png';
}
