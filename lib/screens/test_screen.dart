import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quizsurf/bloc/fichas_bloc.dart';
import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/models/categorias_model.dart';
import 'package:quizsurf/providers/fichas_provider.dart';
import 'package:quizsurf/utils/utils.dart' as utils show shuffle;
import 'package:quizsurf/widgets/opcion_widget.dart';

class TestScreen extends StatefulWidget {
  final categoriaId;
  final nombreCategoria;
  TestScreen({this.categoriaId, this.nombreCategoria});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  CategoriasModel categoria;
  double ancho;
  double alto;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isCargando = true;
  List<FichasModel> fichas = [];
  int totalPreguntas = 0;
  int indexPreguntaActual = 0;
  String preguntaActual = "";
  bool isFin = false;
  bool isUltimaPregunta = false;
  Random rand = new Random();
  Color naranja = Color(0xFFFCA82F);
  bool isCorrecto = null;
  int correctos = 0;
  List<Map<String, dynamic>> opciones = [];
  int indexOpcionElegida = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hacerTest();
  }

  _hacerTest() async {
    fichas = await FichasProvider.db.getBy('id_categoria', widget.categoriaId);
    utils.shuffle(fichas);
    totalPreguntas = fichas.length;
    _siguientePregunta();
  }

  _siguientePregunta() {
    this.isCorrecto = null;
    this.indexOpcionElegida = null;
    if (!isFin) {
      if (indexPreguntaActual + 1 == totalPreguntas) {
        isUltimaPregunta = true;
      }
      preguntaActual = fichas[indexPreguntaActual].tema;
      _generarOpciones();
      if (isUltimaPregunta) isFin = true;
      setState(() {});
      indexPreguntaActual++;
    }
  }

  void _generarOpciones() {
    opciones.clear();
    opciones.add({
      'opcion': fichas[indexPreguntaActual].concepto,
      'isCorrect': true,
      'index': 0
    });

    //Copiar las fichas
    List<FichasModel> auxFichas = [];
    for (var f in fichas) {
      auxFichas.add(f);
    }
    auxFichas.removeAt(indexPreguntaActual);
    //Generar opcion 1
    int indexRand = rand.nextInt(auxFichas.length);

    opciones.add({
      'opcion': auxFichas[indexRand].concepto,
      'isCorrect': false,
      'index': 1
    });

    //Generar opcion 2
    auxFichas.removeAt(indexRand);
    indexRand = rand.nextInt(auxFichas.length);
    opciones.add({
      'opcion': auxFichas[indexRand].concepto,
      'isCorrect': false,
      'index': 2
    });

    utils.shuffle(opciones);
  }

  @override
  Widget build(BuildContext context) {
    print("ES fin? $isFin");
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kMainColor,
      body: SafeArea(
          child: SingleChildScrollView(
        child: !isFin
            ? Column(
                children: <Widget>[
                  _backIcon(context),
                  _nombreCategoria(),
                  _infoPregunta(),
                  _barraProgreso(context),
                  _cardPregunta(),
                ],
              )
            : _resultados(),
      )),
    );
  }

  Widget _resultados() {
    double cal =
        double.parse((10 / totalPreguntas * correctos).toStringAsFixed(2));
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: alto * 0.28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        width: ancho * 0.8,
        height: alto * 0.40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Calificación",
              style: TextStyle(
                color: kTextColor,
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "$cal",
              style: TextStyle(
                color: kMainColor.withOpacity(0.85),
                fontSize: 60.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              cal >= 9.0 ? "😎" : cal >= 7.5 ? "🙂" : cal >= 6.0 ? "😞" : "😭",
              style: TextStyle(fontSize: 40.0),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text(
                    "Volver a intentar 🤗",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    //side: BorderSide(color: kRosaColor),
                  ),
                  onPressed: () {
                    this.correctos = 0;
                    utils.shuffle(fichas);
                    this.isFin = false;
                    this.indexPreguntaActual = 0;
                    this.isCorrecto = null;
                    this.isUltimaPregunta = false;
                    this.indexOpcionElegida = null;
                    this._siguientePregunta();
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              RaisedButton(
                child: Text(
                  "Ahorita no joven 😬",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  //side: BorderSide(color: kRosaColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget _nombreCategoria() {
    return Text(widget.nombreCategoria,
        style: TextStyle(
          fontSize: 30.0,
          color: kTextColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 5.0,
        ));
  }

  Container _barraProgreso(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: alto * 0.02, left: ancho * 0.1),
      child: LinearPercentIndicator(
        width: ancho * 0.8,
        lineHeight: 15.0,
        animationDuration: 1000,
        percent: (indexPreguntaActual * 100 / totalPreguntas) / 100,
        center: Text(
          "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: naranja,
        backgroundColor: kTextColor,
      ),
    );
  }

  Widget _cardPregunta() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: ancho * 0.8,
      height: alto * 0.60,
      child: Column(
        children: <Widget>[
          _cuerpoPregunta(),
          _opciones(),
          SizedBox(
            height: 10.0,
          ),
          _btnSiguiente(context),
        ],
      ),
    );
  }

  Widget _btnSiguiente(BuildContext context) {
    return Container(
      height: 90.0,
      margin: EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              //side: BorderSide(color: kRosaColor),
            ),
            padding: EdgeInsets.all(20.0),
            color: naranja,
            child: Text(isUltimaPregunta ? "Terminar" : "Siguiente",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
            onPressed: () {
              if (this.indexOpcionElegida != null) {
                if (isUltimaPregunta) {
                  Navigator.of(context).pop();
                } else {
                  this._siguientePregunta();
                }
              } else {
                //Toast
                SnackBar snackBar =
                    new SnackBar(content: new Text("Elige una respuesta 🙄"));
                _scaffoldKey.currentState.showSnackBar(snackBar);
              }
            },
          ),
        ],
      ),
    );
  }

  Column _cuerpoPregunta() {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Text(
            "$preguntaActual",
            style: TextStyle(
              color: Color(0xFF294D77),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }

  Column _opciones() {
    return Column(
      children: this.opciones.map((o) {
        return _opcionWidget2(o);
      }).toList(),
    );
  }

  Widget _opcionWidget(Map<String, dynamic> op) {
    return Container(
      height: 60,
      width: ancho * 0.65,
      margin: EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
      decoration: BoxDecoration(
          color: Color(0xFFFCA82F),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 3.0,
            color: Color(0xFFFCA82F).withOpacity(0.5),
          )),
      child: Center(
        child: Text(
          op['opcion'],
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _opcionWidget2(Map<String, dynamic> op) {
    int tipo = 0; //Normal
    if (op['index'] == indexOpcionElegida) {
      if (op['isCorrect'])
        tipo = 1; // Correcto
      else
        tipo = 2; // Fallo
    }

    return GestureDetector(
      onTap: () {
        if (this.isCorrecto == null) {
          setState(() {
            this.isCorrecto = op['isCorrect'];
            if (this.isCorrecto) this.correctos++;
            this.indexOpcionElegida = op['index'];
          });
        }
      },
      child: Container(
        height: 60.0,
        width: ancho * 0.65,
        margin: EdgeInsets.only(top: 18.0, right: 5.0, left: 5.0),
        padding: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            color: tipo == 0
                ? Colors.transparent
                : tipo == 1
                    ? Colors.green.withOpacity(0.9)
                    : Colors.red.withOpacity(0.9),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 1.5,
              color: kTextColor.withOpacity(0.5),
            )),
        child: Center(
          child: Text(
            op['opcion'].toString().trim(),
            style: TextStyle(
                color: tipo == 0
                    ? Color(0xFF294D77).withOpacity(0.8)
                    : Colors.white,
                fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _infoPregunta() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10.0,
      ),
      margin: EdgeInsets.only(
        top: 15.0,
      ),
      child: Row(
        children: <Widget>[
          Text(
            "Pregunta $indexPreguntaActual / $totalPreguntas",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget _backIcon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(3.0),
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: naranja,
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: IconButton(
              icon: Text(
                "X",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ))
      ],
    );
  }
}
