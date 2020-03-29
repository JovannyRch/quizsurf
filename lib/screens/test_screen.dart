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
  TestScreen({this.categoriaId});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  CategoriasModel categoria;
  double ancho;
  double alto;

  bool isCargando = true;
  List<FichasModel> fichas = [];
  int totalPreguntas = 0;
  int indexPreguntaActual = 1;
  String preguntaActual = "";
  bool isFin = false;
  Random rand = new Random();
  Color naranja = Color(0xFFFCA82F);
  List<Map<String, dynamic>> opciones = [];

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

    setState(() {});
  }

  _siguientePregunta() {
    if (indexPreguntaActual + 1 == totalPreguntas) {
      isFin = true;
    } else {
      preguntaActual = fichas[indexPreguntaActual].tema;
      indexPreguntaActual++;
      _generarOpciones();
    }
  }

  void _generarOpciones() {
    opciones.clear();
    opciones.add(
        {'opcion': fichas[indexPreguntaActual].concepto, 'isCorrect': true});

    //Copiar las fichas
    List<FichasModel> auxFichas = [];
    for (var f in fichas) {
      auxFichas.add(f);
    }
    auxFichas.removeAt(indexPreguntaActual);
    //Generar opcion 1
    int indexRand = rand.nextInt(auxFichas.length);

    opciones.add({'opcion': auxFichas[indexRand].concepto, 'isCorrect': false});

    //Generar opcion 2
    auxFichas.removeAt(indexRand);
    indexRand = rand.nextInt(auxFichas.length);
    opciones.add({'opcion': auxFichas[indexRand].concepto, 'isCorrect': false});

    utils.shuffle(opciones);
  }

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF6066D0),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _backIcon(context),
            _infoPregunta(),
            _barraProgreso(context),
            _cardPregunta(),
          ],
        ),
      )),
    );
  }

  Container _barraProgreso(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: alto * 0.02, left: ancho * 0.1),
      child: LinearPercentIndicator(
        width: ancho * 0.8,
        lineHeight: 20.0,
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
      height: alto * 0.50,
      child: Column(
        children: <Widget>[
          _cuerpoPregunta(),
          _opciones(),
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
    return Container(
      height: 60.0,
      width: ancho * 0.65,
      margin: EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 1.5,
            color: kTextColor.withOpacity(0.5),
          )),
      child: Center(
        child: Text(
          op['opcion'].toString().trim(),
          style: TextStyle(color: Color(0xFF86A2C4), fontSize: 20.0),
          textAlign: TextAlign.center,
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
            decoration: BoxDecoration(
              color: Color(0xFFF56459),
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: IconButton(
              icon: Text(
                "X",
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
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
