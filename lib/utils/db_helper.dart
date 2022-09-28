import 'dart:async';

import 'package:item_variance/constant/constant_text.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../models/model.dart';

abstract class DBHelper {
  static Database? _db;

  //============================================================================Initialize
  static init() async {
    try {
      //========================================================================Check Database Value
      if (_db == null) {
        //========================================================================Identify Database Location
        var databasePath = await getDatabasesPath();
        //========================================================================Join Database Location & DB Name
        String path = p.join(databasePath, 'item_variance.db');
        //========================================================================Open Database
        _db = await openDatabase(path, version: 1, onCreate: onCreate);
      }

      return;
    } catch (e) {
      return;
    }
  }

  //============================================================================Create Table
  static FutureOr<void> onCreate(Database db, int version) async {
    String createItemTypeTb =
        "CREATE TABLE ${TableName.itemType} (id INTEGER PRIMARY KEY AUTOINCREMENT, typeName STRING)";
    await db.execute(createItemTypeTb);
  }

  //============================================================================Query
  static Future<List<Map<String, dynamic>>> query(String table) =>
      _db!.query(table);

  //============================================================================Insert
  static Future<int> insert(String table, Model model) async =>
      await _db!.insert(table, model.toJson());

  //============================================================================Update
  static Future<int> update(String table, Model model) async => await _db!
      .update(table, model.toJson(), where: 'id = ?', whereArgs: [model.id]);

  //============================================================================Delete
  static Future<int> delete(String table, Model model) async =>
      await _db!.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
