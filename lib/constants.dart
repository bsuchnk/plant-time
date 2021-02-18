import 'package:flutter/material.dart';

const List possibleDurations = [1, 9, 30, 45, 60, 90, 180];
const List categories = ['study', 'exercise', 'meditation', 'books'];
const List categoryIcons = [
  Icons.fitness_center,
  Icons.school_outlined,
  Icons.sentiment_very_satisfied_outlined,
  Icons.menu_book,
];

const List<String> plants = [
  'drzewko',
  'drzewko_bond',
];

int currentPlant = 0;
int currentPlantPhase = 0;
int currentCategory = 0;

const Color col_ground = Color(0x80DAA520);
const Color col_grass = Color(0xff32cd32);
const Color col_gold = Colors.yellow; //Color(0xFFF0E68C);

int globalDuration = 10;

String plantPath(int plant, int phase) {
  return 'assets/images/' + plants[plant] + phase.toString() + '.png';
}
