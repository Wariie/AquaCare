import 'dart:io';

import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:async';

class AquariumDatabase {
  static late Database _db;
  final _lock = Lock();
  String dbName = "aquarium";

  Future<Database> getDb() async {
    await _lock.synchronized(() async {
      // Check again once entering the synchronized block
      _db = await open();
    });

    return _db;
  }

  Future<Database> get db async {
    return _db;
  }

  Future<Database> open() async {
    if (Platform.isWindows) {
      sqfliteFfiInit();
      var databaseFactory = databaseFactoryFfi;
      _db = await databaseFactory.openDatabase('aquarium.db');
      /*await _db.execute(
          'CREATE TABLE aquariumPhoto (id INTEGER PRIMARY KEY, name TEXT NOT NULL, '
          'aquariumId INTEGER NOT NULL, path TEXT NOT NULL)');
      await _db.execute(
          'CREATE TABLE aquarium (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)');
      await _db.execute(
          'CREATE TABLE measurements (id INTEGER PRIMARY KEY AUTOINCREMENT, date DATETIME NOT NULL, idAquarium INTEGER NOT NULL)');
      await _db.execute(
          'CREATE TABLE measure (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT NOT NULL, '
          'measurementsParentId INTEGER NOT NULL, measureParameterId INTEGER NOT NULL)');
      await _db.execute(
          'CREATE TABLE measureParameter (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, '
          'acronym TEXT UNIQUE NOT NULL, description TEXT)');
      await _db.execute(
          'CREATE TABLE aquariumDetail (id INTEGER PRIMARY KEY AUTOINCREMENT, aquariumId INTEGER, width REAL, '
          'height REAL, length REAL, volume REAL, heatingSystem TEXT, ligthingSystem TEXT, '
          'filtrationSystem TEXT, aquariumName TEXT, style TEXT)');
      var list = getDefaultParameters();
      for (MeasureParameter p in list) {
        await _db.insert(MeasureParameter.typeName, p.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }*/
    } else {
      _db = await openDatabase('aquarium.db', onCreate: _onCreate);
    }
    return _db;
  }

  close() async {
    var dbClient = await getDb();
    await dbClient.close();
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE aquarium (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)');
    await db.execute(
        'CREATE TABLE measurements (id INTEGER PRIMARY KEY AUTOINCREMENT, date DATETIME NOT NULL, idAquarium INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE measure (id INTEGER PRIMARY KEY AUTOINCREMENT, value TEXT NOT NULL, '
        'measurementsParentId INTEGER NOT NULL, measureParameterId INTEGER NOT NULL)');
    await db.execute(
        'CREATE TABLE measureParameter (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, '
        'acronym TEXT NOT NULL, description TEXT)');
    await db.execute(
        'CREATE TABLE aquariumPhoto (id INTEGER PRIMARY KEY, name TEXT NOT NULL, '
        'aquariumId INTEGER NOT NULL, path TEXT NOT NULL');
    await db.execute(
        'CREATE TABLE aquariumDetail (id INTEGER PRIMARY KEY AUTOINCREMENT, aquariumId INTEGER, width REAL, '
        'height REAL, length REAL, volume REAL, heatingSystem TEXT, ligthingSystem TEXT, '
        'filtrationSystem TEXT, aquariumName TEXT, style TEXT)');
  }

  Future<List<Map>> list(String tableName) async {
    var dbClient = await getDb();
    List<Map> list = await dbClient.rawQuery("SELECT * FROM " + tableName);
    return list;
  }

  Future<dynamic> get(String tableName, int id) async {
    var dbClient = await getDb();
    List<Map> results =
        await dbClient.query(tableName, where: "id == " + id.toString());
    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<dynamic> where(String tableName, String where) async {
    var dbClient = await getDb();
    List<Map> results = await dbClient.query(tableName, where: where);
    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<dynamic> listWhereIdInList(String tableName, List<int> ids) async {
    var dbClient = await getDb();
    String where = "id IN (";
    for (var id in ids) {
      where += id.toString() + ",";
    }
    where += ")";
    List<Map> results = await dbClient.query(tableName, where: where);
    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<dynamic> listWhere(String tableName, int whereId,
      {String column = "id"}) async {
    var dbClient = await getDb();
    //List<Map> results = await dbClient.execute();
    List<Map> results = await dbClient.query(tableName,
        where: column.toString() + " == " + whereId.toString());
    return results;
  }

  Future<dynamic> select(
      String tableName, String id, List<String> columns) async {
    var dbClient = await getDb();
    List<Map> results = await dbClient.query(tableName,
        where: "id == " + id.toString(), columns: columns);
    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<int> add(
      String tableName, dynamic elem, String? nullColumnHack) async {
    var dbClient = await getDb();
    return await dbClient.insert(tableName, elem.toMap(),
        nullColumnHack: nullColumnHack);
  }

  Future<void> del(String tableName, dynamic elem) async {
    var dbClient = await getDb();
    await dbClient.delete(tableName, where: "id == " + elem.id.toString());
  }

  Future<dynamic> lastInsert(String tableName,
      {required String whereColumn, required int whereValue}) async {
    var dbClient = await getDb();
    var where = "WHERE $whereColumn == $whereValue";
    List<Map> results = await dbClient.rawQuery(
        "SELECT * FROM " + tableName + " $where ORDER BY id DESC LIMIT 1");
    if (results.isNotEmpty) {
      return results[0];
    } else {
      return null;
    }
  }

  Future<void> edit(String tableName, dynamic elem) async {
    var dbClient = await getDb();
    await dbClient.update(tableName, elem.toMap(),
        where: "id == " + elem.id.toString());
  }
}
