import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globalState/stateValues.dart';
import 'Screens/Signin.dart';
import 'Screens/Signup.dart';
import 'Screens/ExamPage.dart';
import 'Screens/SpeechAnswerPage.dart';

// ProctoringObserver implementation
class ProctoringObserver extends StatefulWidget {
  final Widget child;

  const ProctoringObserver({Key? key, required this.child}) : super(key: key);

  @override
  _ProctoringObserverState createState() => _ProctoringObserverState();
}

class _ProctoringObserverState extends State<ProctoringObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // Navigate to login page if the app is paused or inactive
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/', // Replace '/' with the route of your Signin page if different
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ExamState(),
    child: const MyApp(),
  ));
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
        scaffoldBackgroundColor:
            const Color(0xFFF5F5F5), // Soft background color
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
        buttonTheme: const ButtonThemeData(
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
        '/': (context) => ProctoringObserver(
              child: Signin(),
            ),
        '/signup': (context) => Signup(),
        '/exam': (context) => ProctoringObserver(
              child: ExamPage(
                currentIndex: 0,
                totalIndex: 0,
              ),
            ),
        '/speechanswer': (context) => const ProctoringObserver(
              child: SpeechAnswerPage(),
            ),
      },
    );
  }
}
