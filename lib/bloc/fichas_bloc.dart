import 'dart:async';

import 'package:quizsurf/models/fichas_model.dart';
import 'package:quizsurf/providers/fichas_provider.dart';


class FichasBloc {
  static final FichasBloc _singleton = FichasBloc._internal();

  factory FichasBloc() => _singleton;

  FichasBloc._internal() {
    //Obtener los Scans de la base de datos
    getDatos();
  }

  final _dataController = StreamController<List<FichasModel>>.broadcast();
 
  Stream<List<FichasModel>> get fichas =>
      _dataController.stream;
      /*
  Stream<List<FichasModel>> get scansStreamHttp =>
      _dataController.stream.transform(validarHttp); */

  dispose() {
    _dataController?.close();
  }

  getDatos() async {
    _dataController.sink.add(await FichasProvider.db.getAll());
  }

  deleteData(int id) async {
    await FichasProvider.db.delete(id);
    getDatos();
  }

  deletaALl() async {
    await FichasProvider.db.deleteAll();
    getDatos();
  }

  create(FichasModel ficha) async {
    await FichasProvider.db.insert(ficha);
    getDatos();
  }
}
