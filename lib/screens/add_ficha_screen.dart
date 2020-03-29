import 'package:flutter/material.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/const/const.dart';
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
  TextEditingController terminoCtrl = new TextEditingController();
  TextEditingController conceptoCtrl = new TextEditingController();
  FichasBloc fichasBloc;

  @override
  void initState() {
    super.initState();
    isEdit = widget.ficha.concepto != null;
    if (widget.ficha.tema != null) {
      terminoCtrl.text = widget.ficha.tema;
    }
    if (widget.ficha.concepto != null) {
      conceptoCtrl.text = widget.ficha.concepto;
    }
    this.fichasBloc = new FichasBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  iconSize: 30.0,
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
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Escribe aquí el término 😊',
                        labelText: "Término ✏️",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: kTextColor),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      controller: conceptoCtrl,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: 'Escribe aquí la definición 😜',
                          labelText: "Definición 📝",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kTextColor,
                          )),
                      style: TextStyle(),
                      textAlign: TextAlign.center,
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
                          isEdit ? 'Actualizar' : 'Crear',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          //Si viene una ficha nullla entonces es una nueva ficha

                          print(this.terminoCtrl.text);
                          print(this.conceptoCtrl.text);
                          if (!this.isEdit) {
                            this.fichasBloc.create(new FichasModel(
                                  id_categoria: this.widget.id,
                                  concepto: this.conceptoCtrl.text,
                                  tema: this.terminoCtrl.text,
                                ));
                          } else {
                            print("Actualizar");
                            fichasBloc.edit(new FichasModel(
                                id: this.widget.ficha.id,
                                id_categoria: this.widget.id,
                                concepto: this.conceptoCtrl.text,
                                tema: this.terminoCtrl.text));
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
