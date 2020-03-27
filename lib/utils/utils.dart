import 'dart:math';

import 'package:quizsurf/providers/data_provider.dart';

void shuffle(List list, [int start = 0, int end]) {
  var random = new Random();
  if (end == null) end = list.length;
  int length = end - start;
  while (length > 1) {
    int pos = random.nextInt(length);
    length--;
    var tmp1 = list[start + pos];
    list[start + pos] = list[start + length];
    list[start + length] = tmp1;
  }
}

Future<Map<String, dynamic>> preguntaAleatoria(String materia) async {
  final preguntas = await dataProvider.cargarPreguntas(materia);
  var random = new Random();
  int pos = random.nextInt(preguntas.length);
  return preguntas[pos];
}
