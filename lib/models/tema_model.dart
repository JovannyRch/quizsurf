class TemasModel {
  int id;
  String tema;

  TemasModel({this.id, this.tema});

  factory TemasModel.fromJson(Map<String, dynamic> json) => TemasModel(
        id: json["id"],
        tema: json["tema"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tema": tema,
      };
}
