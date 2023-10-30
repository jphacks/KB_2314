import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

// database table and column names
// パラメータの定義

class NotificationSQLHelper {
  static final tableText = 'texts';
  static final columnId = '_id';
  static final columnText = 'text';
  static final NT_Hour = 'nt_hour';
  static final NT_Minutes = 'nt_minutes';
  static final NT_Day = 'nt_day';
  static final NT_CategoryNumber = 'nt_categorynumber';
  static final NT_NID = 'nt_nid';
  static final NT_State = 'nt_state';

  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        test TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        $NT_Hour INTEGER NOT NULL,
        $NT_Minutes INTEGER NOT NULL,
        $NT_Day INTEGER,
        $NT_CategoryNumber INTEGER,
        $NT_State INTEGER
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'notification.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String title, String? descrption, String? testl,
      int? hour, int? minu, int? day, int? cat, int? state) async {
    final db = await NotificationSQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'test': testl,
      NT_Hour: hour,
      NT_Minutes: minu,
      NT_Day: day,
      NT_CategoryNumber: cat,
      NT_State: state
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Create new item (notification)
  static Future<int> createNotificationbeta(
      int? hour, int? minu, int? cat) async {
    final db = await NotificationSQLHelper.db();

    final data = {
      NT_Hour: hour,
      NT_Minutes: minu,
      NT_CategoryNumber: cat,
      NT_State: 1
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await NotificationSQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await NotificationSQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Read MAXid
  static Future<List<Map<String, dynamic>>> getmaxID() async {
    final db = await NotificationSQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Update an item by id
  static Future<int> updateItem(int id, String title, String? descrption,
      String? testl, int? hour, int? minu, int? day, int? cat) async {
    final db = await NotificationSQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'test': testl,
      NT_Hour: hour,
      NT_Minutes: minu,
      NT_Day: day,
      NT_CategoryNumber: cat,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<int> updateState(int id, int? state) async {
    final db = await NotificationSQLHelper.db();
    final data = {'nt_state': state};

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> changeState(int id, int state) async {
    final db = await NotificationSQLHelper.db();
    final data = {'nt_state': 1 - state};

    await db.update("items", data, where: "id = ?", whereArgs: [id]);
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await NotificationSQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  // DeleteAll
  static Future<void> deleteAllItem() async {
    final db = await NotificationSQLHelper.db();
    try {
      await db.delete("items");
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
