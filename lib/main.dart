import 'package:flutter/material.dart';
import 'package:quizsurf/screens/home_screen.dart';
import 'package:quizsurf/screens/quiz_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Surf',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/quiz': (context) => QuizScreen(),
      },
    );
  }
}
