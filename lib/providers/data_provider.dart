import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class _DataProvider {
  _DataProvider();
  Future<List> cargarPreguntas(String colecccion) async {
    final resp = await rootBundle.loadString('data/data.json');
    Map dataMap = json.decode(resp);
    return dataMap[colecccion];
  }
}

final dataProvider = _DataProvider();
