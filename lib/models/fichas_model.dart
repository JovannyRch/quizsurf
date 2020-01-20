class FichasModel {
  int id;
  String tema;
  String concepto;
  int id_categoria;

  FichasModel({this.id, this.concepto, this.tema, this.id_categoria});

  factory FichasModel.fromJson(Map<String, dynamic> json) => FichasModel(
        id: json["id"],
        tema: json["tema"],
        concepto: json["concepto"],
        id_categoria: json["id_categoria"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tema": tema,
        "concepto": concepto,
        "id_categoria": id_categoria,
      };
}
