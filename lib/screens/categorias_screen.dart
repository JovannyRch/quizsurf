import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CategoriasScreen extends StatelessWidget {
  double alto;
  double ancho;

  List<Map<String, dynamic>> categorias = [
    {
      'titulo': 'Matemáticas',
      'color1': Color.fromRGBO(241, 142, 17, 1.0),
      'color2': Color.fromRGBO(236, 98, 18, 1.0),
    },
    {
      'titulo': 'Geografía',
      'color1': Color.fromRGBO(0, 142, 17, 1.0),
      'color2': Color.fromRGBO(0, 98, 18, 1.0),
    },
    {
      'titulo': 'Historia',
      'color1': Color.fromRGBO(241, 0, 17, 1.0),
      'color2': Color.fromRGBO(236, 0, 18, 1.0),
    },
    {
      'titulo': 'Inglés',
      'color1': Color.fromRGBO(120, 142, 0, 1.0),
      'color2': Color.fromRGBO(100, 98, 0, 1.0),
    },
  ];

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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                Text(
                  "¿List@ para aprender?",
                  style: TextStyle(
                    fontSize: this.alto * 0.04,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: alto * 0.035,
                ),
                CarouselSlider(
                  height: alto * 0.5,
                  viewportFraction: 0.9,
                  items: categorias.map((categoria) {
                    var materia = categoria['titulo'];
                    Color color1 = categoria['color1'];
                    Color color2 = categoria['color2'];
                    return CardMateria(
                        materia: materia, color1: color1, color2: color2);
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
                  "Pregunta del día",
                  style: TextStyle(
                      color: Colors.blue.shade900,
                      letterSpacing: 1.7,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CardMateria extends StatelessWidget {
  CardMateria({this.materia, this.color1, this.color2});
  final String materia;
  final Color color1;
  final Color color2;

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
                height: alto * 0.1,
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
                        fontSize: alto * 0.03,
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
              onPressed: () {
                Navigator.of(context).pushNamed('/quiz');
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
}
