import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/providers/data_provider.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int segundos = 50;
  final int tiempoInicial = 4;
  int preguntaActual = 0;
  int total = 10;
  int fallos = 0;
  double width;
  double height;
  int contadorSegundos = 0;
  int indexPage = 0;
  List<bool> historial = [];
  int puntos = 0;
  List<Map> preguntas = [];
  String id = "";
  @override
  void initState() {
    super.initState();
    this.cargarPreguntas();
    segundos = tiempoInicial;
    Timer.periodic(new Duration(seconds: 1), (timer) {
      setState(() {
        contadorSegundos++;
        segundos--;
        if (contadorSegundos == 3) {
          this.indexPage = 1;
        }
      });

      if (segundos == 0) {
        timer.cancel();
        setState(() {
          //this.indexPage = 2;
        });
        Alert(
          context: context,
          type: AlertType.warning,
          title: "TIEMPO AGOTADO",
          desc: "Sigue estudiando y preparandote :)",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  void cargarPreguntas() async {
    final preguntas = await dataProvider.cargarPreguntas('historia');
    for (var p in preguntas) {
      print(p['pregunta']);
    }
    //print(preguntas);
  }

  @override
  Widget build(BuildContext context) {
    this.id = ModalRoute.of(context).settings.arguments.toString();

    this.height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: SafeArea(
        child: IndexedStack(
          index: this.indexPage,
          children: <Widget>[
            pantallaInicio(context),
            cuerpoJuego(context),
            finJuego(context),
          ],
        ),
      ),
    );
  }

  Widget finJuego(BuildContext context) {
    return Container(
      child: Text("Hola"),
    );
  }

  Widget pantallaInicio(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            this.contadorSegundos.toString(),
            style: TextStyle(color: Colors.white, fontSize: 50.0),
          ),
        ],
      ),
    );
  }

  Widget getFallos() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: builderFallos(),
      ),
    );
  }

  List<Widget> builderFallos() {
    List<Widget> res = [];
    for (int i = 0; i < this.fallos; i++) {
      res.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
    return res;
  }

  SingleChildScrollView cuerpoJuego(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          barraProgreso(context),
          infoPregunta(),
          SizedBox(
            height: 10.0,
          ),
          getFallos(),
          SizedBox(
            height: 10.0,
          ),
          preguntas.length == 0
              ? CircularPercentIndicator(
                  radius: 10.0,
                )
              : preguntaBuilder(this.preguntas[this.preguntaActual]),
          preguntas.length == 0
              ? CircularPercentIndicator(
                  radius: 10.0,
                )
              : opcionesBuilder(
                  this.preguntas[this.preguntaActual]['opciones']),
          /*  botonSiguiente(), */
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Rendirse',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.grey),
                  ))
            ],
          ),
        ],
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
          this.height * 0.03,
        ),
        child: Text(
          "Siguiente",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: this.height * 0.03,
          ),
        ),
      ),
      color: Color(0xff117EEB),
    );
  }

  Widget opcionesBuilder(List<Map<String, dynamic>> opciones) {
    return Container(
      width: double.infinity,
      child: Column(
        children: opciones
            .map((opcion) => GestureDetector(
                onTap: () {
                  if (opcion['isCorrect']) {
                    print("Has acertado");
                    opcion['estado'] = 2;
                    this.puntos++;
                  } else {
                    print("Incorrecto");
                    opcion['estado'] = 3;
                    this.fallos++;
                    if (this.fallos == 3) {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Fin del Juego",
                        desc: "Te has equivocado 3 veces",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "OK",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () => Navigator.pop(context),
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  }
                  setState(() {});
                  Timer(
                      Duration(milliseconds: 750),
                      () => {
                            setState(() {
                              if (this.preguntaActual + 1 ==
                                  this.preguntas.length) {
                                this.preguntaActual = 0;
                              } else {
                                this.preguntaActual++;
                              }
                            })
                          });
                },
                child: OpcionWidget(
                  texto: opcion['opcion'],
                  isCorrect: opcion['isCorrect'],
                  estado: opcion['estado'],
                )))
            .toList(),
      ),
    );
  }

  Widget preguntaBuilder(Map pregunta) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      height: this.height * 0.14,
      child: Text(
        pregunta['pregunta'],
        style: TextStyle(
          color: Colors.white,
          fontSize: this.height * 0.04,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container barraProgreso(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: height * 0.02, left: width * 0.08),
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
        top: this.height * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          getNumeroPregunta(),
          getPuntos(),
        ],
      ),
    );
  }

  Widget getNumeroPregunta() {
    return Row(
      children: <Widget>[
        Text(
          'Pregunta ${preguntaActual.toString()}',
          style: TextStyle(
            color: Color(0xff8D94BB),
            fontSize: this.height * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '/ ${this.total.toString()}',
          style: TextStyle(
            color: Color(0xff8D94BB),
            fontSize: this.height * 0.026,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget getPuntos() {
    return Row(
      children: <Widget>[
        /* Text(
          'Puntos:',
          style: TextStyle(
            color: kTextColor,
            fontSize: this.height * 0.027,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ), */
        Text(
          '${this.puntos}',
          style: TextStyle(
            color: kTextColor,
            fontSize: this.height * 0.045,
          ),
        ),
        Icon(
          Icons.check,
          color: kTextColor,
          size: 30.0,
        ),
        SizedBox(
          width: this.width * 0.080,
        )
      ],
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
    double alto = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        margin: EdgeInsets.only(bottom: alto * 0.02),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              width: 3.0,
              color: Color(0xFF21486A),
            )),
        child: ListTile(
          title: Text(
            widget.texto,
            style: TextStyle(color: Colors.white, fontSize: alto * 0.03),
          ),
          trailing: getIcon(widget.estado),
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
        backgroundColor: Colors.green,
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
