import 'dart:math';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quizsurf/const/const.dart';
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:quizsurf/utils/utils.dart' as utils;
import 'package:vibration/vibration.dart';

enum Operaciones { suma, resta, multiplicacion, division }

class MatematicasScreen extends StatefulWidget {
  MatematicasScreen({Key key}) : super(key: key);

  @override
  _MatematicasScreenState createState() => _MatematicasScreenState();
}

class _MatematicasScreenState extends State<MatematicasScreen> {
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
  List<Map<String, dynamic>> preguntas = [];
  String id = "";
  bool isFinJuego = false;
  int nivel = 0;
  Timer timer;

  Map<int, List<Map<String, int>>> rangos;

  //Valores por defecto
  String pregunta;
  int operando1 = 0;
  int operando2 = 0;
  int cantPregXnivel = 0;
  int contadorPreguntas = 0;
  Operaciones operacion = Operaciones.suma;
  Random rand = new Random();
  List<Map<String, dynamic>> opciones = [];
  int max = 100;
  int min = 0;
  int dificultad = 1;

  @override
  void initState() {
    super.initState();
    rangos = utils.getRangos();

    iniciarJuego();
  }

  void iniciarJuego() {
    //Configurar maximos y min valores iniciales
    this.min = rangos[this.nivel][this.dificultad]['min'];
    this.max = rangos[this.nivel][this.dificultad]['max'];
    this.cantPregXnivel = rangos[this.nivel][this.dificultad]['cantidad'];
    this.generarPregunta();
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
                "Volver a jugar",
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
          this.nivel = 0;
          this.contadorPreguntas = 0;
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

  void generarPregunta() {
    //Generar valores aleatorios según el nivel

    //Checar cambio de nivel
    if (this.contadorPreguntas == this.cantPregXnivel) {
      this.contadorPreguntas = 0;
      this.nivel++;
      print("Rangos");
      print(rangos);
      this.min = rangos[this.nivel][this.dificultad]['min'];
      this.max = rangos[this.nivel][this.dificultad]['max'];
      this.cantPregXnivel = rangos[this.nivel][this.dificultad]['cantidad'];
      print("Cambio de nivel $nivel");
      print("min: $min, max = $max, cant: $cantPregXnivel");
    }
    print("Contador: $contadorPreguntas");

    this.opciones.clear();
    operando1 = this.randomInRange(max, min);
    operando2 = this.randomInRange(max, min);
    double resultado = 0;
    //Generar una operacion aleatoria
    int tipoOperacion = rand.nextInt(4);
    print("Tipo de operacion $tipoOperacion");
    switch (tipoOperacion) {
      case 0:
        operacion = Operaciones.suma;
        this.pregunta = "$operando1 + $operando2";
        resultado = operando1.toDouble() + operando2.toDouble();
        break;
      case 1:
        this.pregunta = "$operando1 - $operando2";
        operacion = Operaciones.resta;
        resultado = operando1.toDouble() - operando2.toDouble();
        break;
      case 2:
        this.pregunta = "$operando1 x $operando2";
        operacion = Operaciones.multiplicacion;
        resultado = operando1.toDouble() * operando2.toDouble();
        break;
      case 3:
        var aux = operando1 * operando2;
        resultado = operando1.toDouble();
        operando1 = aux;
        this.pregunta = "$operando1 / $operando2";
        operacion = Operaciones.division;
        if (operando2 == 0) operando2 = 1;
        resultado = operando1.toDouble() / operando2.toDouble();
        break;
    }
    print("Pregunta " + this.pregunta);
    //Generar respuestas
    this.opciones = this.generarRespuestas(resultado);
    //print(this.opciones);
    setState(() {});

    this.contadorPreguntas++;
  }

  // Creador de respuestas
  //Cantidad: Cantidad de respuestas
  List<Map<String, dynamic>> generarRespuestas(double resultado,
      {cantidad: 2}) {
    List<double> respuestas = [];
    while (respuestas.length < cantidad) {
      //Tipos de respuesta Random
      var tipo = this.rand.nextInt(100);
      var propuesta = resultado;
      var resultadoStr = '$resultado';
      int n = resultadoStr.length;
      //print("EL valor de n $n");
      //Suffle
      if ((tipo >= 0 && tipo < 25) && resultadoStr.length > 1) {
        utils.shuffle(resultadoStr.split(''));
        propuesta = double.parse(resultadoStr);
      }

      //Acercamiento a la respuesta en un intevalo bajo
      if (tipo >= 25 && tipo <= 60) {
        var porcentaje = resultado ~/ 10;
        propuesta = resultado + this.randomInRange(-porcentaje, porcentaje);
      }

      //Diferencias de 10*size
      if (tipo > 60 && tipo <= 100) {
        var numero = this.randomInRange(n, -n);
        propuesta = resultado + numero * 10;
      }

      if (propuesta != resultado && !(respuestas.indexOf(propuesta) >= 0))
        respuestas.add(propuesta);
    }

    List<Map<String, dynamic>> prev = [
      {'opcion': "${resultado.toInt()}", 'isCorrect': true}
    ];

    //print("REspuestas: $respuestas");
    for (var r in respuestas) {
      //print("Add $r");
      prev.add({'opcion': "${r.toInt()}", 'isCorrect': false});
    }
    utils.shuffle(prev);
    return prev;
  }

  int randomInRange(int max, int min) {
    if (max == 0) {
      max = 10;
      //print("Max es 0");
    }
    if (max < 0) max = max * -1;
    if (min == max) min = min * -1;
    //print("Un valor random entre $max y $min");
    return min + rand.nextInt(max - min);
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
            style: TextStyle(color: Colors.white, fontSize: 60.0),
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
        size: 20.0,
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
          preguntaBuilder(this.pregunta),
          opcionesBuilder(this.opciones),
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
                  if (opcion['isCorrect']) {
                    print("Has acertado");
                    opcion['estado'] = 2;
                    this.puntos++;
                    this.generarPregunta();
                  } else {
                    print("Incorrecto");
                    Vibration.vibrate(duration: 250);

                    opcion['estado'] = 3;
                    this.fallos++;
                    if (this.fallos == 3) {
                      this.isFinJuego = true;
                      bool resp = await await Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Has fallado 3 veces",
                        desc: "Tu puntuación $puntos",
                        buttons: [
                          DialogButton(
                            color: kTextColor,
                            child: Text(
                              "Salir",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            width: 120,
                          ),
                          DialogButton(
                            color: kRosaColor,
                            child: Text(
                              "Volver a jugar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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
                        this.nivel = 0;
                        this.contadorPreguntas = 0;
                        this.historial.clear();
                        this.indexPage = 0;
                        this.contadorSegundos = 0;
                        this.isFinJuego = false;
                        this.iniciarJuego();
                      } else {
                        Navigator.pop(context);
                      }
                    } else {
                      this.generarPregunta();
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

  Widget preguntaBuilder(String pregunta) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      height: this.height * 0.14,
      child: Text(
        pregunta,
        style: TextStyle(
          color: Colors.white,
          fontSize: this.height * 0.08,
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
            textAlign: TextAlign.center,
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
