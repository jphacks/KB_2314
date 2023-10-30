import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
// パラメータの定義
const String tableText = 'texts';
const String columnId = '_id';
const String columnText = 'text';
const String NT_Hour = 'nt_hour';
const String NT_Minutes = 'nt_minutes';
const String NT_Day = 'nt_day';
const String NT_CategoryNumber = 'nt_categorynumber';
const String NT_NID = 'nt_nid';

// data model class
// データベースの定義
class NTDatabase {
  String? word;

  int? id;
  int? hour;
  int? minu;
  int? day;
  int? cat;
  int? Nid;

  NTDatabase();

  // convenience constructor to create a Word object
  NTDatabase.fromMap(Map<dynamic, dynamic> map) {
    word = map[columnText];
    hour = map[NT_Hour];
    minu = map[NT_Minutes];
    id = map[columnId];
    day = map[NT_Day];
    cat = map[NT_CategoryNumber];
    Nid = map[NT_NID];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnText: word,
      NT_Hour: hour,
      NT_Minutes: minu,
      NT_Day: day,
      NT_CategoryNumber: cat,
      NT_NID: Nid,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
// データの操作する関数をまとめてる
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = "TestDatabase0123.db";
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableText (
                $columnId INTEGER PRIMARY KEY,
                $columnText TEXT NOT NULL,
                $NT_Hour INTEGER NOT NULL,
                $NT_Minutes INTEGER NOT NULL,
                $NT_Day INTEGER NOT NULL,
                $NT_CategoryNumber INTEGER NOT NULL,
                $NT_NID INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(NTDatabase ntd) async {
    Database? db = await database;
    int id = await db!.insert(tableText, ntd.toMap());
    return id;
  }

  Future<List> queryWord() async {
    Database? db = await database;
    List<Map> maps = await db!.rawQuery('SELECT * FROM $tableText');
    List<NTDatabase> data = [];
    if (maps.isNotEmpty) {
      for (Map m in maps) {
        data.add(NTDatabase.fromMap(m));
      }
    }
    return data;
  }

  // Delete a record
  Future<int> deleteAll() async {
    Database? db = await database;
    int count = await db!.rawDelete('DELETE FROM $tableText');
    return count;
  }

  Future<int> update(NTDatabase ntd) async {
    Database? db = await database;
    return await db!.update(tableText, ntd.toMap(),
        where: '$columnId = ?', whereArgs: [ntd.id]);
  }
}
