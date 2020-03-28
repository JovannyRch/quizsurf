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
  print("Materia $materia");
  final preguntas = await dataProvider.cargarPreguntas(
      materia == "" || materia == null ? 'geografia' : materia);
  var random = new Random();
  int pos = random.nextInt(preguntas.length);
  return preguntas[pos];
}

Map<int, List<Map<String, int>>> getRangos() {
  return {
    0: [
      {"min": 0, "max": 2, "cantidad": 3},
      {"min": 0, "max": 5, "cantidad": 3},
      {"min": 0, "max": 15, "cantidad": 5},
    ],
    1: [
      {"min": 0, "max": 3, "cantidad": 5},
      {"min": 2, "max": 8, "cantidad": 7},
      {"min": 10, "max": 50, "cantidad": 5},
    ],
    2: [
      {"min": 1, "max": 5, "cantidad": 5},
      {"min": 4, "max": 14, "cantidad": 7},
      {"min": 40, "max": 80, "cantidad": 5},
    ],
    3: [
      {"min": 1, "max": 6, "cantidad": 7},
      {"min": 4, "max": 20, "cantidad": 7},
      {"min": 60, "max": 130, "cantidad": 5},
    ],
    4: [
      {"min": 1, "max": 7, "cantidad": 11},
      {"min": 5, "max": 30, "cantidad": 7},
      {"min": 100, "max": 300, "cantidad": 5},
    ],
    5: [
      {"min": 1, "max": 8, "cantidad": 11},
      {"min": 10, "max": 45, "cantidad": 11},
      {"min": 250, "max": 500, "cantidad": 5},
    ],
    6: [
      {"min": 1, "max": 9, "cantidad": 11},
      {"min": 15, "max": 55, "cantidad": 11},
      {"min": 450, "max": 900, "cantidad": 5},
    ],
    7: [
      {"min": 1, "max": 10, "cantidad": 777},
      {"min": 25, "max": 75, "cantidad": 7},
      {"min": 750, "max": 1000, "cantidad": 5},
    ],
    8: [
      {"min": 2, "max": 10, "cantidad": 11},
      {"min": 30, "max": 100, "cantidad": 7},
      {"min": 900, "max": 1500, "cantidad": 7},
    ],
    9: [
      {"min": 3, "max": 10, "cantidad": 11},
      {"min": 80, "max": 130, "cantidad": 7},
      {"min": 1400, "max": 2800, "cantidad": 7},
    ],
    10: [
      {"min": 4, "max": 10, "cantidad": 11},
      {"min": 100, "max": 180, "cantidad": 11},
      {"min": 2500, "max": 6000, "cantidad": 11},
    ],
    11: [
      {"min": 5, "max": 10, "cantidad": 13},
      {"min": 150, "max": 250, "cantidad": 11},
      {"min": 5000, "max": 12000, "cantidad": 11},
    ],
    12: [
      {"min": 6, "max": 10, "cantidad": 15},
      {"min": 200, "max": 500, "cantidad": 11},
      {"min": 12000, "max": 24000, "cantidad": 11},
    ],
    13: [
      {"min": 7, "max": 10, "cantidad": 15},
      {"min": 200, "max": 500, "cantidad": 11},
      {"min": 20000, "max": 10000, "cantidad": 300},
    ],
    14: [
      {"min": 0, "max": 67, "cantidad": 17},
      {"min": 300, "max": 500, "cantidad": 11},
      {"min": 20000, "max": 10000, "cantidad": 300},
    ],
    15: [
      {"min": 0, "max": 99, "cantidad": 300},
      {"min": 100, "max": 1000, "cantidad": 300},
      {"min": 20000, "max": 10000, "cantidad": 300},
    ]
  };
}
