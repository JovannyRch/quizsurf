import 'dart:math';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  static final textColor = Color.fromRGBO(20, 40, 150, 1);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final caja = Transform.rotate(
      angle: -pi / 2.8,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70.0),
          color: Colors.grey.shade200,
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.turned_in),
            title: Text('Marcadores'),
          )
        ],
      ),
    );
  }

  Container cuerpoBuilder() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50.0,
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
          ),
          SizedBox(
            height: 30.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hola Daniela",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "¿Lista para aprender?",
                  style: TextStyle(
                    fontSize: 40.0,
                    color: Colors.blue.shade900,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 30.0,
                ),
                CarouselSlider(
                  height: 400.0,
                  viewportFraction: 0.9,
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return CardMateria(context: context);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
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
  const CardMateria({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(241, 142, 17, 1.0).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 1,
            offset: Offset(5, 0), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(25.0),
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(241, 142, 17, 1.0),
              Color.fromRGBO(236, 98, 18, 1.0),
            ]),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Matemáticas',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RaisedButton(
              color: Colors.grey.shade200,
              child: Container(
                width: 140.0,
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'INICIAR',
                      style: TextStyle(
                        color: Color.fromRGBO(236, 98, 18, 1.0),
                        fontSize: 22.0,
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
                      backgroundColor: Color.fromRGBO(236, 98, 18, 1.0),
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
