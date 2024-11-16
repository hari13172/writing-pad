import 'package:flutter/material.dart';
import 'package:new_app/Screens/PreviewPage.dart';
import 'package:new_app/Screens/SpeechAnswerPage.dart';
import 'package:new_app/Screens/WriteAnswerPage.dart';
import 'Screens/Signin.dart';
import 'Screens/Signup.dart';
import 'Screens/ExamPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/exam': (context) => ExamPage(),
        'writeanswer': (context) => WriteAnswerPage(),
        '/speechanswer': (context) => SpeechAnswerPage(),
        '/preview': (context) => PreviewPage(answer: ''),
      },
    );
  }
}
