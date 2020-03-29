import 'dart:io';

import 'package:quizsurf/models/fichas_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:quizsurf/const/const.dart';

class FichasProvider {
  static Database _database;
  static final FichasProvider db = FichasProvider._();

  String dbName = kDBname;
  String tabla = "fichas";
  FichasProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, '$dbName.db');
    return await openDatabase(path,
        version: 1, onCreate: (Database db, int version) async {});
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

  Future<FichasModel> getByIdCategoria(int idCategoria) async {
    final db = await database;
    final res = await db
        .query(tabla, where: 'id_categoria = ?', whereArgs: [idCategoria]);
    return res.isNotEmpty ? FichasModel.fromJson(res.first) : null;
  }

  Future<List<FichasModel>> getAll() async {
    final db = await database;
    final res = await db.query(tabla);
    return res.isEmpty
        ? []
        : res.map((registro) => FichasModel.fromJson(registro)).toList();
  }

  Future<List<FichasModel>> getBy(String campo, int valor) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * from $tabla where $campo = $valor");
    return res.isEmpty
        ? []
        : res.map((registro) => FichasModel.fromJson(registro)).toList();
  }

  Future<int> update(FichasModel tarjeta) async {
    final db = await database;
    final res = await db.update(tabla, tarjeta.toJson(),
        where: 'id = ?', whereArgs: [tarjeta.id]);
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
