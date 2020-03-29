import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/categorias_bloc.dart';
import 'package:quizsurf/const/const.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    this.categoriasBloc = new CategoriasBloc();
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30.0,
                      color: kTextColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Escribe el título 😍',
                    labelText: "Título ✏️",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                    hintStyle: TextStyle(
                      color: kTextColor,
                    )),
                textAlign: TextAlign.center,
                onChanged: (valor) {
                  print(valor);
                  this.titulo = valor;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                decoration: InputDecoration(
                    hintText: 'Escribe una breve descripción 👀',
                    labelText: "Descripción 🗒",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                    hintStyle: TextStyle(
                      color: kTextColor,
                    )),
                style: TextStyle(),
                textAlign: TextAlign.center,
                onChanged: (valor) {
                  this.descripcion = valor;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: RaisedButton(
                  color: kTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    //side: BorderSide(color: kRosaColor),
                  ),
                  child: Text(
                    "Crear",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (this.titulo != "") {
                      this.categoriasBloc.create(new CategoriasModel(
                          nombre: this.titulo, descripcion: this.descripcion));
                      Navigator.pop(context);
                    } else {
                      //Toast
                      SnackBar snackBar = new SnackBar(
                          content: new Text("Agrega el título 🙄"));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                  },
                  //color: kRosaColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
