import 'package:flutter/material.dart';
import 'package:quizsurf/providers/fichas_provider.dart';

class FichasScreen extends StatelessWidget {
  FichasProvider fichasProvider = FichasProvider();

  @override
  Widget build(BuildContext context) {
    this.fichasProvider.getFichas();
    return Container(
      child: Text("hola"),
    );
  }
}
