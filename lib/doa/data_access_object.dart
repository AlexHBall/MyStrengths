import 'dart:async';
import 'package:my_strengths/models/entry.dart';
import 'package:my_strengths/models/frequency.dart';
import 'package:my_strengths/database/database.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy");
final String entryTable = 'Entry_table';
final String frequencyTable = 'Frequency_table';
final String colId = 'id';
final String colDescription = 'description';
final String colDate = 'date';
final String colTime = 'time';
final String colTimeType = 'timeType';
final String colDuration = 'duration';

class MyStrengthsDao {
  String today = dateFormat.format(DateTime.now());

  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Map<String, dynamic>>> getEntryMapList() async {
    final db = await dbProvider.database;
    var result = await db.query(entryTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<int> insertEntry(Entry entry) async {
    final db = await dbProvider.database;
    var result = await db.insert(entryTable, entry.toMap());
    return result;
  }

  Future<int> updateEntry(Entry entry) async {
    final db = await dbProvider.database;
    var result = await db.update(entryTable, entry.toMap(),
        where: '$colId = ?', whereArgs: [entry.id]);
    return result;
  }

  Future<int> deleteEntry(int id) async {
    final db = await dbProvider.database;
    int result =
        await db.rawDelete('DELETE FROM $entryTable WHERE $colId = $id');
    return result;
  }

  Future<List<Entry>> getEntryList() async {
    var entryMapList = await getEntryMapList(); // Get 'Map List' from database
    int count =
        entryMapList.length; // Count the number of map entries in db table

    List<Entry> entryList = List<Entry>();
    // For loop to create a 'Entry List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }
    return entryList;
  }

  Future<List<Entry>> getTodaysList() async {
    final db = await dbProvider.database;
    var entryMapList = await db.query(entryTable,
        where: "$colDate = '$today'", orderBy: '$colTime ASC');
    int count =
        entryMapList.length; // Count the number of map entries in db table

    List<Entry> entryList = List<Entry>();
    // For loop to create a 'Entry List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      entryList.add(Entry.fromMapObject(entryMapList[i]));
    }
    return entryList;
  }

  Future<int> insertFrequency(Frequency frequency) async {
    final db = await dbProvider.database;
    var result = await db.insert(frequencyTable, frequency.toMap());
    return result;
  }

  Future<int> updateFrequency(Frequency frequency) async {
    final db = await dbProvider.database;
    var result = await db.update(frequencyTable, frequency.toMap(),
        where: '$colId = ?', whereArgs: [frequency.id]);
    return result;
  }

  Future<int> deleteFrequency(int id) async {
    final db = await dbProvider.database;
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
      frequencyList.add(Frequency.fromMapObject(frequencyMapList[i]));
    }
    return frequencyList;
  }

  Future<List<Map<String, dynamic>>> getFrequencyMapList() async {
    final db = await dbProvider.database;
    var result = await db.query(frequencyTable);
    return result;
  }
}