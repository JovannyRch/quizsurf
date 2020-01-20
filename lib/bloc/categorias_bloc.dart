import 'dart:async';

import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/providers/categorias_provider.dart';
import 'package:quizsurf/providers/fichas_provider.dart';


class CategoriasBloc {
  static final CategoriasBloc _singleton = CategoriasBloc._internal();

  factory CategoriasBloc() => _singleton;

  CategoriasBloc._internal() {
    //Obtener los Scans de la base de datos
    getDatos();
  }

  final _dataController = StreamController<List<CategoriasModel>>.broadcast();
 
  Stream<List<CategoriasModel>> get categorias =>
      _dataController.stream;
      /*
  Stream<List<CategoriasModel>> get scansStreamHttp =>
      _dataController.stream.transform(validarHttp); */

  dispose() {
    _dataController?.close();
  }

  getDatos() async {
    _dataController.sink.add(await CategoriasProvider.db.getAll());
  }

  deleteData(int id) async {
    await CategoriasProvider.db.delete(id);
    getDatos();
  }

  deletaALl() async {
    await CategoriasProvider.db.deleteAll();
    getDatos();
  }

  create(CategoriasModel ficha) async {
    await CategoriasProvider.db.insert(ficha);
    getDatos();
  }
}
