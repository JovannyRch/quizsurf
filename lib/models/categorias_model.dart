

class CategoriasModel {
  int id;
  String nombre;
  String descripcion;

  CategoriasModel({
    this.id,
    this.nombre,
    this.descripcion
  });

  factory CategoriasModel.fromJson(Map<String, dynamic> json) => CategoriasModel(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion
      };

}
