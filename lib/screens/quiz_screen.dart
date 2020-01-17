import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  QuizScreen({Key key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int segundos = 50;
  final int tiempoInicial = 15;
  int preguntaActual = 1;
  int total = 10;

  @override
  void initState() {
    super.initState();
    segundos = tiempoInicial;
    Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        segundos--;
      });
      if (segundos == 0) {
        segundos = tiempoInicial;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252C4A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              barraProgreso(context),
              infoPregunta(),
              SizedBox(
                height: 30.0,
              ),
              preguntaBuilder(),
              opcionesBuilder(),
              botonSiguiente()
            ],
          ),
        ),
      ),
    );
  }

  RaisedButton botonSiguiente() {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      onPressed: () {
        this.preguntaActual++;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.all(
          24.0,
        ),
        child: Text(
          "Siguiente",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
      color: Color(0xff117EEB),
    );
  }

  Widget opcionesBuilder() {
    return Container(
      child: Column(
        children: <Widget>[
          OpcionWidget(
            texto: 'Tarántula',
            isCorrect: true,
          ),
          OpcionWidget(
            texto: 'Échatelo',
          ),
          OpcionWidget(
            texto: 'Canción',
          ),
          OpcionWidget(
            texto: 'Agonía',
          )
        ],
      ),
    );
  }

  Widget preguntaBuilder() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      height: 180.0,
      child: Text(
        '¿Cúal es una palabra esdrújula?',
        style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container barraProgreso(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, left: 30.0),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width - 50,
        lineHeight: 20.0,
        animationDuration: 1000,
        percent: (segundos * 100 / tiempoInicial) / 100,
        center: Text(
          segundos.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Color(0xFFE05CA4),
      ),
    );
  }

  Container infoPregunta() {
    return Container(
      padding: EdgeInsets.only(
        left: 30.0,
        top: 40.0,
      ),
      child: Row(
        children: <Widget>[
          Text(
            'Pregunta ${preguntaActual.toString()}',
            style: TextStyle(
              color: Color(0xff8D94BB),
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/ ${this.total.toString()}',
            style: TextStyle(
              color: Color(0xff8D94BB),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}

class OpcionWidget extends StatefulWidget {
  String texto;
  int estado;
  bool isCorrect;
  OpcionWidget({this.texto, this.estado = 1, this.isCorrect = false});

  @override
  _OpcionWidgetState createState() => _OpcionWidgetState();
}

class _OpcionWidgetState extends State<OpcionWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (this.widget.isCorrect) {
          this.widget.estado = 2;
        } else {
          this.widget.estado = 3;
        }
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 15.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                width: 5.0,
                color: Color(0xFF21486A),
              )),
          child: ListTile(
            title: Text(
              widget.texto,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: getIcon(widget.estado),
          ),
        ),
      ),
    );
  }

  getIcon(int estado) {
    if (estado == 1) {
      return CircleAvatar(
        backgroundColor: Color(0xFF21486A),
        radius: 15.0,
        child: CircleAvatar(
          backgroundColor: Color(0xFF252C4A),
          radius: 12.0,
        ),
      );
    }
    if (estado == 2) {
      return CircleAvatar(
        backgroundColor: Color(0xff117EEB),
        radius: 15.0,
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 20.0,
        ),
      );
    }
    if (estado == 3) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: 15.0,
        child: Icon(
          Icons.close,
          color: Colors.white,
          size: 20.0,
        ),
      );
    }
  }
}
