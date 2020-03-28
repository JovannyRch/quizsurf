import 'dart:io';

import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CategoriasProvider {
  static Database _database;
  static final CategoriasProvider db = CategoriasProvider._();
  String tabla = "categorias";
  String dbName = kDBname;
  CategoriasProvider._() {}

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$dbName.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
        "CREATE TABLE categorias"
        "(id INTEGER PRIMARY KEY,"
        "nombre text,"
        "descripcion text"
        ")",
      );
      await db.execute(
        "CREATE TABLE fichas"
        "(id INTEGER PRIMARY KEY,"
        "tema text,"
        "concepto text,"
        "id_categoria INTEGER,"
        "FOREIGN KEY(id_categoria) REFERENCES categorias(id) ON DELETE CASCADE"
        ")",
      );
      await db.execute(
        "CREATE TABLE records"
        "(id INTEGER PRIMARY KEY,"
        "materia text,"
        "record integer,"
        "intentos INTEGER,"
        "fallos INTEGER,"
        "aciertos INTEGER,"
        ")",
      );
    });
  }

  insert(CategoriasModel scan) async {
    final db = await database;
    return await db.insert(tabla, scan.toJson());
  }

  Future<CategoriasModel> getById(int id) async {
    final db = await database;
    final res = await db.query(tabla, where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? CategoriasModel.fromJson(res.first) : null;
  }

  Future<List<CategoriasModel>> getAll() async {
    final db = await database;
    final res = await db.query(tabla);
    return res.isEmpty
        ? []
        : res.map((registro) => CategoriasModel.fromJson(registro)).toList();
  }

  Future<List<CategoriasModel>> getBy(String campo, String valor) async {
    final db = await database;
    final res =
        await db.rawQuery("SELECT * from $tabla where $campo = '$valor'");
    return res.isEmpty
        ? []
        : res.map((registro) => CategoriasModel.fromJson(registro)).toList();
  }

  Future<int> update(CategoriasModel tajeta) async {
    final db = await database;
    final res = await db.update(tabla, tajeta.toJson(),
        where: 'id = ?', whereArgs: [tajeta.id]);
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
