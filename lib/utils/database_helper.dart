import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/entry.dart';
import '../models/frequency.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy");

class DatabaseHelper {
  String today = dateFormat.format(DateTime.now());

  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  static const String entryTable = 'Entry_table';
  static const String frequencyTable = 'Frequency_table';
  static const String colId = 'id';
  static const String colDescription = 'description';
  static const String colDate = 'date';
  static const String colTime = 'time';
  static const String colTimeType = 'timeType';
  static const String colDuration = 'duration';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'Entrys.db';
    debugPrint("Path [$path]");
    // Open/create the database at a given path
    var entrysDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return entrysDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $entryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT, '
        '$colDate TEXT, $colTime TEXT)');

    await db.execute(
        'CREATE TABLE $frequencyTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTimeType TEXT, '
        '$colDuration INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getEntryMapList() async {
    Database db = await this.database;
    var result = await db.query(entryTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<int> insertEntry(Entry entry) async {
    Database db = await this.database;
    var result = await db.insert(entryTable, entry.toMap());
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    var db = await this.database;
    var result = await db.update(entryTable, entry.toMap(),
        where: '$colId = ?', whereArgs: [entry.id]);
    return result;
  }

  Future<int> deleteEntry(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $entryTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $entryTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Entry>> getEntryList() async {
    var entryMapList = await getEntryMapList(); // Get 'Map List' from database
    int count =
        entryMapList.length; // Count the number of map entries in db table

    List<Entry> entryList = List<Entry>();
    // For loop to create a 'Entry List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      debugPrint("Adding to EntryList $entryMapList[i]");
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }
    return entryList;
  }

  Future<List<Entry>> getTodaysList() async {
    Database db = await this.database;
    var entryMapList = await db.query(entryTable,
        where: "$colDate = '$today'", orderBy: '$colTime ASC');
    int count =
        entryMapList.length; // Count the number of map entries in db table

    List<Entry> entryList = List<Entry>();
    // For loop to create a 'Entry List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      debugPrint("Adding to today's EntryList $entryMapList[i]");
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }
    return entryList;
  }

  Future<int> insertFrequency(Frequency frequency) async {
    Database db = await this.database;
    final insert = frequency.toMap();
    debugPrint("inserting Frequency $insert");
    var result = await db.insert(frequencyTable, frequency.toMap());
    return result;
  }

  Future<int> updateFrequency(Frequency frequency) async {
    var db = await this.database;
    var result = await db.update(frequencyTable, frequency.toMap(),
        where: '$colId = ?', whereArgs: [frequency.id]);
    return result;
  }

  Future<int> deleteFrequency(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $frequencyTable WHERE $colId = $id');
    return result;
  }

  Future<List<Frequency>> getFrequencyList() async {
    var frequencyMapList =
        await getFrequencyMapList(); // Get 'Map List' from database
    int count =
        frequencyMapList.length; // Count the number of map entries in db table

    List<Frequency> frequencyList = List<Frequency>();
    // For loop to create a 'Entry List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      debugPrint("Adding to FrequencyList $frequencyMapList[i]");
      frequencyList.add(Frequency.fromMapObject(frequencyMapList[i]));
    }
    return frequencyList;
  }

  Future<List<Map<String, dynamic>>> getFrequencyMapList() async {
    Database db = await this.database;
    var result = await db.query(frequencyTable);
    return result;
  }
}
