import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Objects/reference_rock.dart';
import '../Objects/collection_rock.dart';
class DB  {
  static final DB _db = DB._internal();
  DB._internal();
  static DB get instance => _db;
  static Database? _database;

  final dbName = "rock_db.db";
  final dbVersion = 3;

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await _init();
    return _database!;
  }

  Future<Database> _init() async{
    return await openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, dbVersion) {
        db.execute(ReferenceRock.createRockTable);
        db.execute(CollectionRock.createRocksTable);
      },
      version: dbVersion,
    );
  }

  final String createCollectionTable = "";

  loadRefData() async {
    try{
      final String res = await rootBundle.loadString('assets/data/JSON/data.json');
      final data = await jsonDecode(res);
      Iterable rockJson = data['items'];
      List<ReferenceRock> rocks = List<ReferenceRock>.from(
          rockJson.map((r) => ReferenceRock.fromJson(r))
      );
      for (var r in rocks) {
        insertReferenceRock(r);
      }
    }on Exception catch (_, e){
      print(e.toString());
    }
  }

  Future<void> insertCollectionRock(CollectionRock rock)async {
    final db = await database;
    db.insert(CollectionRock.tableName, rock.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> upDateCollectionRock(CollectionRock rock) async {
    final db = await database;
    db.update(CollectionRock.tableName, rock.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<void> deleteCollectionRock(CollectionRock rock) async {
    final db = await database;
    db.delete(CollectionRock.tableName, where: "id=?", whereArgs: [rock.id]);
  }

  Future<List<CollectionRock>> getAllCollectionRocks() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(CollectionRock.tableName);
    return List.generate(maps.length,
            (i) => CollectionRock.fromJson(maps[i]));
  }

  Future<void> insertReferenceRock(ReferenceRock r) async {
    final db = await database;
    await db.insert(ReferenceRock.tableName, r.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ReferenceRock>> getAllRefRocks({bool alpha = false}) async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ReferenceRock.tableName);
    List<ReferenceRock> rocks = List.generate(
            maps.length,
            (index) => ReferenceRock.fromJson(maps[index]));
    if(alpha) {
        rocks.sort((a,b) {
        if(a.title != null && b.title!= null) return a.title!.compareTo(b.title!);
        return 0;
      });
    }
    return rocks;
  }
}