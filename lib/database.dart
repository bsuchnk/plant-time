import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:timer_app/sessioninfo.dart';
import 'dart:core';
import 'dart:developer' as developer;

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    String directory = await getDatabasesPath();
    String path = join(directory, 'plant_time_database.db');

    final Future<Database> database = openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE sessions("
          "date INTEGER NOT NULL PRIMARY KEY,"
          "duration INTEGER NOT NULL,"
          "category TEXT NOT NULL,"
          "plant INTEGER NOT NULL"
          ")",
        );
      },
      // TEMPORARY, FOR TESTING:
      // onOpen: (Database db) async {
      //   //   await db.execute(
      //   //     "DROP TABLE sessions",
      //   //   );
      //   // },
      //   await db.execute(
      //     "CREATE TABLE sessions("
      //     "date INTEGER NOT NULL PRIMARY KEY,"
      //     "duration INTEGER NOT NULL,"
      //     "category TEXT NOT NULL,"
      //     "plant INTEGER NOT NULL"
      //     ")",
      //   );
      // },
    );

    return database;
  }

  Future<int> addSessionInfoToDatabase(SessionInfo sessionInfo) async {
    final db = await database;
    Future<int> raw = db.insert(
      "sessions",
      sessionInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<SessionInfo>> getAllSessionInfos() async {
    final db = await database;
    var response = await db.query("sessions");
    List<SessionInfo> list =
        response.map((c) => SessionInfo.fromMap(c)).toList();
    return list;
  }

  Future<List<SessionInfo>> getSessionInfosBetween(
    DateTime date1,
    DateTime date2,
  ) async {
    final db = await database;
    var response = await db.rawQuery(
        'SELECT * FROM sessions WHERE date BETWEEN '
        '${date1.microsecondsSinceEpoch} AND ${date2.microsecondsSinceEpoch}');
    List<SessionInfo> list =
        response.map((c) => SessionInfo.fromMap(c)).toList();
    return list;
  }
}
