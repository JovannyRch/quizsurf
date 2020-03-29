import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/providers/data_provider.dart';
import 'package:quizsurf/widgets/opcion_widget.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:quizsurf/utils/utils.dart' as utils;
import 'package:vibration/vibration.dart';

class QuizScreen extends StatefulWidget {
  final String materia;
  final int tiempoInicial;
  QuizScreen(this.materia, this.tiempoInicial);
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int segundos = 50;
  int tiempoInicial;
  int preguntaActual = 0;
  int total = 10;
  int fallos = 0;
  double width;
  double height;
  int contadorSegundos = 0;
  int indexPage = 0;
  List<bool> historial = [];
  int puntos = 0;
  List<Map<String, dynamic>> preguntas = [];
  String id = "";
  bool isFinJuego = false;
  Timer timer;
  bool isTapped = false;
  @override
  void initState() {
    this.tiempoInicial = this.widget.tiempoInicial;
    this.id = widget.materia;
    super.initState();
    //print("LA materia es $id");
    this.iniciarJuego();
  }

  void iniciarJuego() {
    this.cargarPreguntas(this.id);
    segundos = tiempoInicial;
    timer = Timer.periodic(new Duration(seconds: 1), (timer) async {
      if (mounted) {
        setState(() {
          contadorSegundos++;
          segundos--;
          if (contadorSegundos == 3) {
            this.indexPage = 1;
          }
        });
      }
      if (segundos == 0) {
        timer.cancel();
        this.isFinJuego = true;
        bool resp = await await Alert(
          context: context,
          type: AlertType.warning,
          title: "Tiempo agotado",
          desc: "Tu puntuación $puntos",
          buttons: [
            DialogButton(
              color: kTextColor,
              child: Text(
                "Salir",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              width: 120,
            ),
            DialogButton(
              color: kRosaColor,
              child: Text(
                "Reintentar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              width: 120,
            )
          ],
        ).show();
        if (resp != null && resp) {
          this.segundos = this.tiempoInicial;
          this.puntos = 0;
          this.fallos = 0;
          this.preguntaActual = 0;

          this.historial.clear();
          this.indexPage = 0;
          this.contadorSegundos = 0;
          this.isFinJuego = false;
          this.iniciarJuego();
        } else {
          Navigator.pop(context);
        }
      }

      if (this.isFinJuego) {
        timer.cancel();
      }
    });
  }

  void cargarPreguntas(String materia) async {
    final preguntas = await dataProvider.cargarPreguntas(materia);
    for (var p in preguntas) {
      Map<String, dynamic> preg = {
        'pregunta': p['pregunta'],
      };

      List<Map<String, dynamic>> ops = [];
      for (var opc in p['opciones']) {
        ops.add({'opcion': opc['opcion'], 'isCorrect': opc['isCorrect']});
      }
      preg['opciones'] = ops;
      //Mezclar opciones
      utils.shuffle(preg['opciones']);
      this.preguntas.add(preg);
      //this.preguntas.add(preg['pregunta']);
    }
    //Mezlar preguntas
    utils.shuffle(this.preguntas);
  }

  @override
  Widget build(BuildContext context) {
    //this.id = ModalRoute.of(context).settings.arguments.toString();

    this.height = MediaQuery.of(context).size.height;
    this.width = MediaQuery.of(context).size.width;
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
            (3 - this.contadorSegundos).toString(),
            style: TextStyle(color: Colors.white, fontSize: 55.0),
          ),
        ],
      ),
    );
  }

  Widget getFallos() {
    return Container(
      height: 20.0,
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
        if (mounted) {
          setState(() {
            this.preguntaActual++;
          });
        }
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
                onTap: () async {
                  if (isTapped == false) {
                    isTapped = true;
                    if (opcion['isCorrect']) {
                      //print("Has acertado");
                      opcion['estado'] = 2;
                      this.puntos++;
                    } else {
                      //print("Incorrecto");
                      Vibration.vibrate(duration: 250);
                      opcion['estado'] = 3;
                      this.fallos++;
                      if (this.fallos == 3) {
                        this.isFinJuego = true;
                        bool resp = await Alert(
                          context: context,
                          type: AlertType.warning,
                          title: "Has fallado 3 veces",
                          desc: "Tu puntuación $puntos",
                          buttons: [
                            DialogButton(
                              color: kTextColor,
                              child: Text(
                                "Salir",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              width: 120,
                            ),
                            DialogButton(
                              color: kRosaColor,
                              child: Text(
                                "Reintentar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              width: 120,
                            )
                          ],
                        ).show();
                        if (resp != null && resp) {
                          this.segundos = this.tiempoInicial;
                          this.puntos = 0;
                          this.fallos = 0;
                          this.preguntaActual = 0;
                          this.historial.clear();
                          this.indexPage = 0;
                          this.contadorSegundos = 0;
                          this.isFinJuego = false;
                          this.iniciarJuego();
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    }
                    setState(() {});
                    Timer(
                        Duration(milliseconds: 750),
                        () => {
                              setState(() {
                                isTapped = false;
                                if (this.preguntaActual + 1 ==
                                    this.preguntas.length) {
                                  this.preguntaActual = 0;
                                } else {
                                  this.preguntaActual++;
                                }
                              })
                            });
                  }
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
      height: this.height * 0.21,
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
        ), /* 
        Text(
          '/ ${this.total.toString()}',
          style: TextStyle(
            color: Color(0xff8D94BB),
            fontSize: this.height * 0.026,
            fontWeight: FontWeight.bold,
          ),
        ), */
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
