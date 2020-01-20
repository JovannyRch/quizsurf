import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quizsurf/screens/categorias_fichas_screen.dart';
import 'package:quizsurf/screens/categorias_screen.dart';
import 'package:quizsurf/screens/fichas_inicio_screen.dart';

class HomeScreen extends StatefulWidget {
  static final textColor = Color.fromRGBO(20, 40, 150, 1);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          CategoriasScreen(),
          CategoriasFichasScreen(),
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_week),
            title: Text('Inicio'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            title: Text('Fichas'),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
