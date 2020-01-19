

class FichasModel {
  int id;
  String tema;
  String concepto;

  FichasModel({
    this.id,
    this.concepto,
    this.tema,
  }) {
   
  }

  factory FichasModel.fromJson(Map<String, dynamic> json) => FichasModel(
        id: json["id"],
        tema: json["tema"],
        concepto: json["concepto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tema": tema,
        "concepto": concepto,
      };

}
