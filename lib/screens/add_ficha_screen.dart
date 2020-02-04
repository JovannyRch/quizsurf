import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/models/fichas_model.dart';

class AddFichaScreen extends StatefulWidget {
  final id;
  FichasModel ficha = new FichasModel();
  AddFichaScreen({this.id, this.ficha});

  @override
  _AddFichaScreenState createState() => _AddFichaScreenState();
}

class _AddFichaScreenState extends State<AddFichaScreen> {
  String termino = "";
  String definicion = "";
  bool isEdit = false;

  FichasBloc fichasBloc;
  @override
  Widget build(BuildContext context) {
    isEdit = widget.ficha.concepto != null;
    TextEditingController terminoCtrl = new TextEditingController();
    TextEditingController conceptoCtrl = new TextEditingController();
    if (widget.ficha.tema != null) {
      terminoCtrl.text = widget.ficha.tema;
    }
    if (widget.ficha.concepto != null) {
      conceptoCtrl.text = widget.ficha.concepto;
    }
    this.fichasBloc = new FichasBloc();
    return Scaffold(
      body: Container(
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
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: terminoCtrl,
                      decoration: InputDecoration(
                        hintText: 'Escriba aquí el término',
                        labelText: "Término",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                      onChanged: (valor) {
                        this.termino = valor;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: conceptoCtrl,
                      minLines: 4,
                      maxLines: 10,
                      decoration: InputDecoration(
                          hintText: 'Escriba aquí la definición',
                          labelText: "Definición",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      style: TextStyle(),
                      textAlign: TextAlign.center,
                      onChanged: (valor) {
                        this.definicion = valor;
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: RaisedButton(
                        color: Colors.blue,
                        child: Text(
                          isEdit ? 'Editar' : 'Crear',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //Si viene una ficha entonces es una nueva ficha
                          if (widget.ficha == null) {
                            this.fichasBloc.create(new FichasModel(
                                id_categoria: this.widget.id,
                                concepto: this.definicion,
                                tema: this.termino));
                          } else {
                            /* this.fichasBloc.(new FichasModel(
                              id_categoria: this.widget.id,
                              concepto: this.definicion,
                              tema: this.termino)); */
                          }
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
