class OpcionesModel {
  String opcion;
  bool isCorrect;
  int idPregunta;

  OpcionesModel({this.opcion, this.isCorrect, this.idPregunta});

  factory OpcionesModel.fromJson(Map<String, dynamic> json) => OpcionesModel(
        opcion: json["opcion"],
        isCorrect: json["isCorrect"],
      );

  Map<String, dynamic> toJson() => {
        "opcion": opcion,
        "isCorrect": isCorrect,
      };
}
