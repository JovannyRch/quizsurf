import 'dart:io';

import 'package:quizsurf/models/fichas_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class FichasProvider {
  static Database _database;
  static final FichasProvider db = FichasProvider._();
  String tabla = "fichas";
  FichasProvider._() {}

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$tabla.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE $tabla"
        "(id INTEGER PRIMARY KEY,"
        "tema text,"
        "concepto text"
        ")",
      );
    });
  }

  insert(FichasModel scan) async {
    final db = await database;
    return await db.insert(tabla, scan.toJson());
  }

  Future<FichasModel> getById(int id) async {
    final db = await database;
    final res = await db.query(tabla, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? FichasModel.fromJson(res.first) : null;
  }

  Future<List<FichasModel>> getAll() async {
    final db = await database;
    final res = await db.query(tabla);
    return res.isEmpty
        ? []
        : res.map((registro) => FichasModel.fromJson(registro)).toList();
  }

  Future<List<FichasModel>> getBy(String campo, String valor) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * from $tabla where $campo = '$valor'");
    return res.isNotEmpty
        ? []
        : res.map((registro) => FichasModel.fromJson(registro)).toList();
  }

  Future<int> update(FichasModel tajeta) async {
    final db = await database;
    final res = await db
        .update(tabla, tajeta.toJson(), where: 'id = ?', whereArgs: [tajeta.id]);
    return res;
  }

  Future<int> delete(int id) async {
    final db = await database;
    final res = await db.delete(tabla, where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete("DELETE from $tabla");
    return res;
  }
}
