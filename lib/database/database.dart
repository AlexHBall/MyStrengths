import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String entryTable = 'Entry_table';
final String frequencyTable = 'Frequency_table';
final String colId = 'id';
final String colDescription = 'description';
final String colDate = 'date';
final String colTime = 'time';
final String colTimeType = 'timeType';
final String colDuration = 'duration';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //"ReactiveTodo.db is our database instance name
    String path = join(documentsDirectory.path, "MyStengths.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);

    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $entryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDescription TEXT, '
        '$colDate TEXT, $colTime TEXT)');

    await db.execute(
        'CREATE TABLE $frequencyTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTimeType TEXT, '
        '$colDuration INTEGER)');
  }
}
