import 'package:flutter/material.dart';
import 'Screens/Signin.dart';
import 'Screens/Signup.dart';
import 'Screens/ExamPage.dart';
import 'Screens/WriteAnswerPage.dart';
import 'Screens/SpeechAnswerPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accessible Learning App',
      theme: ThemeData(
        // **Accessibility-Oriented Global Styles**
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Soft background color
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Lexend Deca', // Font designed for readability
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Lexend Deca',
            fontSize: 18,
            color: Color(0xFF333333),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Lexend Deca',
            fontSize: 16,
            color: Color(0xFF333333),
          ),
          labelLarge: TextStyle(
            fontFamily: 'Lexend Deca',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blue, // High contrast button color
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      // **Navigation Routes**
      initialRoute: '/',
      routes: {
        '/': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/exam': (context) => const ExamPage(),
        '/writeanswer': (context) => const WriteAnswerPage(),
        '/speechanswer': (context) => const SpeechAnswerPage(),
      },
    );
  }
}
