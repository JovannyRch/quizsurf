import 'package:flutter/material.dart';

class PuntajeScreen extends StatelessWidget {
  const PuntajeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Text("TU puntaje fue"),
      )),
    );
  }
}
