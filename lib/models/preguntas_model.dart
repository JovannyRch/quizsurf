class PreguntasModel {
  String pregunta;

  PreguntasModel({this.pregunta});

  factory PreguntasModel.fromJson(Map<String, dynamic> json) => PreguntasModel(
        pregunta: json["pregunta"],
      );

  Map<String, dynamic> toJson() => {"pregunta": pregunta};
}
