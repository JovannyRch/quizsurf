import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/models/fichas_model.dart';

class AddFichaScreen extends StatefulWidget {
  final id;
  AddFichaScreen({this.id});

  @override
  _AddFichaScreenState createState() => _AddFichaScreenState();
}

class _AddFichaScreenState extends State<AddFichaScreen> {
  String termino = "";
  String definicion = "";

  FichasBloc fichasBloc;
  @override
  Widget build(BuildContext context) {
    this.fichasBloc = new FichasBloc();
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
                hintText: 'Escriba aquí el término',
                labelText: "Término",
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              textAlign: TextAlign.center,
              onSubmitted: (valor) {
                print(valor);
                this.termino = valor;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Escriba aquí la definición',
                  labelText: "Definición",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              style: TextStyle(),
              textAlign: TextAlign.center,
              onSubmitted: (valor) {
                this.definicion = valor;
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
                  this.fichasBloc.create(new FichasModel(
                      id_categoria: this.widget.id,
                      concepto: this.definicion,
                      tema: this.termino));
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
