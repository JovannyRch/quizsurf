import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:quizsurf/const/const.dart';
import 'package:quizsurf/screens/matematicas_screen.dart';
import 'package:quizsurf/screens/quiz_screen.dart';
import 'package:quizsurf/utils/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CategoriasScreen extends StatelessWidget {
  double alto;
  double ancho;
  String preguntaDia = "";
  String categoria = "";
  String nombreMateria = "";
  bool isContestado = false; //Guarda si ya está contestado la pregunta del día
  List<Map<String, dynamic>> categorias = [
    {
      'titulo': 'Geografía',
      'color1': Color.fromRGBO(0, 142, 17, 1.0),
      'color2': Color.fromRGBO(0, 98, 18, 1.0),
      'id': 'geografia',
      'fondo': 'images/geografia.png'
    },
    {
      'titulo': 'Historia',
      'color1': Color.fromRGBO(141, 70, 97, 1.0),
      'color2': Color.fromRGBO(136, 50, 68, 1.0),
      'id': 'historia',
      'fondo': 'images/roma.png'
    },
    {
      'titulo': 'Inglés',
      'color1': Color.fromRGBO(120, 142, 0, 1.0),
      'color2': Color.fromRGBO(100, 98, 0, 1.0),
      'id': 'ingles',
      'fondo': 'images/ingles.png'
    },
    {
      'titulo': 'Ciencia',
      'color1': Color.fromRGBO(40, 42, 110, 1.0),
      'color2': Color.fromRGBO(20, 65, 90, 1.0),
      'id': 'ciencia',
      'fondo': 'images/ciencia.png'
    },
  ];

  CategoriasScreen() {
    //

    this.categorias.add({
      'titulo': 'Matemáticas',
      'color1': Color.fromRGBO(241, 142, 17, 1.0),
      'color2': Color.fromRGBO(236, 98, 18, 1.0),
      'fondo': 'images/matematicas.png',
      'id': 'matematicas'
    });
  }
  Future<Map<String, dynamic>> _preguntaDelDia() async {
    var hoy = new DateTime.now().toIso8601String().split(":")[0];
    //Verificar si en preferences settings esta el
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var diaGuardado = prefs.getString("fechaActual");
    if (diaGuardado == null) {
      prefs.setString("fechaActual", hoy);
      diaGuardado = hoy;
    }
    //print("Dia guardado: $diaGuardado");
    //print("hoy: $hoy");
    var preguntaDelDia = prefs.getString("preguntaDia");
    if (diaGuardado != hoy || preguntaDelDia == null || preguntaDelDia == "") {
      //Generar pregunta y guardar hoy  como en la variable de día guardado
      prefs.setString("fechaActual", hoy);
      prefs.setBool('isContestado', false);
      //Obtener pregunta con sus opciones aleatoriamente
      Map<String, dynamic> preg = await this._generarPreguntaAleatoria();
      //Guardarlas
      prefs.setString('preguntaDia', preg['pregunta']);
      prefs.setString('materia', preg['materia']);
      int index = 0;
      for (var op in preg['opciones']) {
        prefs.setString(
            'opc$index', "${op['opcion']}%%%%${op['isCorrect'] ? '1' : '0'}");
        //print(prefs.getString('opc$index'));
        index++;
      }

      return preg;
    } else {
      //No generar nueva pregunta
      //cargar la pregunta guarda y devolverla
      this.isContestado = prefs.getBool('isContestado');
      this.nombreMateria = prefs.getString(('materia'));
      if (!isContestado) {
        List<Map<String, dynamic>> ops = [];
        for (int i = 0; i < 3; i++) {
          String op = prefs.getString('opc$i');
          String p1 = op.split("%%%%")[0];
          String p2 = op.split("%%%%")[1];
          //print("Opcion guardada $op");
          ops.add({'opcion': p1, 'isCorrect': p2 == "1"});
        }
        return {'pregunta': prefs.getString('preguntaDia'), 'opciones': ops};
      }
    }
  }

  Future<Map<String, dynamic>> _generarPreguntaAleatoria() async {
    var random = new Random();
    //-1 para no incluir a la materia de matemáticas
    int pos = random.nextInt(this.categorias.length - 1);
    //print("Generando pregunta aleatoria");
    //print(pos);
    this.categoria = this.categorias[pos]['id'];
    this.nombreMateria = this.categorias[pos]['titulo'];

    var data = await utils.preguntaAleatoria(this.categoria);
    final opciones = data['opciones'];
    var pregunta = data['pregunta'].toString();
    if (!pregunta.contains("¿")) {
      pregunta = "¿$pregunta?";
    }
    return {
      'pregunta': pregunta,
      'opciones': opciones,
      'materia': this.nombreMateria
    };
  }

  @override
  Widget build(BuildContext context) {
    this.alto = MediaQuery.of(context).size.height;
    this.ancho = MediaQuery.of(context).size.width;
    final caja = Transform.rotate(
      angle: -pi / 2.8,
      child: Container(
        width: this.ancho * .5,
        height: this.alto * .5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
          color: Colors.grey.shade200,
        ),
      ),
    );
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -160.0,
              left: 160,
              child: caja,
            ),
            cuerpoBuilder(),
          ],
        ),
      ),
    );
  }

  Container cuerpoBuilder() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Container(
            height: this.alto*0.08,
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {},
                ), 
                Expanded(
                  child: Container(),
                ),
                CircleAvatar(
                  child: Icon(Icons.account_circle),
                )
              ],
            ),
          ),*/
          SizedBox(height: this.alto * 0.02),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /* Text(
                  "Hola Daniela",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue.shade900,
                  ),
                ), 
                SizedBox(
                  height: 10.0,
                ),*/
                /*  Text(
                  "¿List@ para aprender?",
                  style: TextStyle(
                    fontSize: this.alto * 0.04,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.start,
                ), */
                SizedBox(
                  height: alto * 0.01,
                ),
                CarouselSlider(
                  height: alto * 0.47,
                  viewportFraction: 0.8,
                  items: categorias.map((categoria) {
                    var materia = categoria['titulo'];
                    Color color1 = categoria['color1'];
                    Color color2 = categoria['color2'];
                    //print("Fondo ${categoria['fondo']}");
                    return CardMateria(
                        materia: materia,
                        color1: color1,
                        color2: color2,
                        id: categoria['id'],
                        fondo: categoria['fondo']);
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: alto * 0.02,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/idea.png',
                  width: 28.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Pregunta del día 🤔",
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      letterSpacing: 1.7,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          this.isContestado == false
              ? FutureBuilder(
                  future: _preguntaDelDia(),
                  builder: (BuildContext context, snapshot) {
                    //print("Cargando la pregunta");
                    //print(snapshot.data);
                    if (snapshot.hasData) {
                      final pregunta = snapshot.data['pregunta'];
                      final opciones = snapshot.data['opciones'];
                      List<Widget> preguntaWidgets = [
                        Text(
                          this.nombreMateria,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "$pregunta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ];

                      utils.shuffle(opciones);
                      for (var o in opciones) {
                        preguntaWidgets.add(Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          margin: EdgeInsets.symmetric(
                            vertical: 3.0,
                          ),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlatButton(
                                  //shape: ShapeBorder.,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(color: kTextColor)),
                                  child: Text(
                                    o['opcion'],
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    String titulo;
                                    AlertType a;
                                    if (o['isCorrect']) {
                                      titulo = "¡Correcto! 🙃";
                                      a = AlertType.success;
                                    } else {
                                      titulo = "¡Incorrecto! 🥺";
                                      a = AlertType.error;
                                    }
                                    Alert(
                                      context: context,
                                      type: a,
                                      title: titulo,
                                      buttons: [
                                        DialogButton(
                                          color: kTextColor,
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          width: 120,
                                        ),
                                      ],
                                    ).show();
                                  },
                                )
                              ]),
                        ));
                      }

                      return Container(
                        width: ancho * 0.95,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: preguntaWidgets,
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                )
              : Container(
                  child: Text("Ya contestaste la pregunta"),
                )
        ],
      ),
    );
  }
}

class CardMateria extends StatelessWidget {
  CardMateria({this.materia, this.color1, this.color2, this.id, this.fondo});
  final String materia;
  final Color color1;
  final Color color2;
  final String fondo;
  final id;

  @override
  Widget build(BuildContext context) {
    double alto = MediaQuery.of(context).size.height;
    double ancho = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: this.color1.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(5, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(25.0),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [this.color1, this.color2]),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 150.0,
              child: FittedBox(
                child: Image.asset(fondo),
                fit: BoxFit.cover,
              ),
            ),
            Text(
              materia,
              style: TextStyle(
                fontSize: alto * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: alto * 0.03,
            ),
            RaisedButton(
              color: Colors.grey.shade200,
              child: Container(
                width: MediaQuery.of(context).size.width * .50,
                height: alto * 0.09,
                padding: EdgeInsets.symmetric(
                  vertical: alto * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'INICIAR',
                      style: TextStyle(
                        color: this.color1,
                        fontSize: alto * 0.025,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    CircleAvatar(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.grey.shade200,
                      ),
                      backgroundColor: this.color1,
                    )
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(40.0),
              ),
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return Container(
                        height: alto * 0.4,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Elije el tiempo ⏰",
                              style:
                                  TextStyle(color: kTextColor, fontSize: 30.0),
                            ),
                            SizedBox(height: 20.0),
                            _opcionTiempo("5 Minutos 👶", () {
                              this.goGame(303, context);
                            }),
                            _opcionTiempo("3 Minutos 😜", () {
                              this.goGame(183, context);
                            }),
                            _opcionTiempo("1 Minuto 😳", () {
                              this.goGame(63, context);
                            }),
                          ],
                        ),
                        padding: EdgeInsets.all(40.0),
                      );
                    });
              },
            ),
            Container(
              width: double.infinity,
              height: 40.0,
            )
          ],
        ),
      ),
    );
  }

  ListTile _opcionTiempo(String txt, Function f) {
    return ListTile(
      title: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
            side: BorderSide(color: kTextColor)),
        onPressed: f,
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: kTextColor,
            fontSize: 24.0,
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void goGame(int tiempoInicial, BuildContext context) {
    Navigator.of(context).pop();
    if (this.id != "matematicas") {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext) => new QuizScreen(this.id, tiempoInicial)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext) => new MatematicasScreen(
                tiempoInicial: tiempoInicial,
              )));
    }
  }
}
