import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/categorias_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';

class AddCategoriaScreen extends StatefulWidget {
  AddCategoriaScreen({Key key}) : super(key: key);

  @override
  _AddCategoriaScreenState createState() => _AddCategoriaScreenState();
}

class _AddCategoriaScreenState extends State<AddCategoriaScreen> {
  bool fase2 = false;
  String titulo = "";
  String descripcion = "";
  CategoriasBloc categoriasBloc;
  @override
  Widget build(BuildContext context) {
    this.categoriasBloc = new CategoriasBloc();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Título de la guía',
                labelText: "Título",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              textAlign: TextAlign.center,
              onSubmitted: (valor) {
                print(valor);
                this.titulo = valor;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Ingrese una breve descripción',
                  labelText: "Descripción",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              style: TextStyle(),
              textAlign: TextAlign.center,
              onSubmitted: (valor) {
                this.descripcion = valor;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: FlatButton(
                child: Text(
                  "Crear",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  this.categoriasBloc.create(new CategoriasModel(
                      nombre: this.titulo, descripcion: this.descripcion));
                  Navigator.pop(context);
                },
                color: Colors.blueGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
