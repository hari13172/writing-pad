import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON decoding
import 'dart:io'; // For platform checks
import 'package:flutter_dnd/flutter_dnd.dart'; // DND package
import 'Signup.dart';
import 'ExamPage.dart';
import '../globalState/stateValues.dart';
import 'package:provider/provider.dart'; // Import provider

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController registerController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool _dndEnabled = false; // Track if DND is enabled

  @override
  void initState() {
    super.initState();
    _checkAndEnableDND();
  }

  @override
  void dispose() {
    _disableDND(); // Restore notifications on exit
    super.dispose();
  }

  Future<void> _checkAndEnableDND() async {
    if (!Platform.isAndroid) {
      debugPrint("DND mode is only supported on Android.");
      return;
    }

    try {
      final isGranted = await FlutterDnd.isNotificationPolicyAccessGranted;

      if (isGranted == null || !isGranted) {
        FlutterDnd.gotoPolicySettings(); // Redirect to system settings
        return;
      }

      await _enableDND();
    } catch (e) {
      debugPrint("Error checking/enabling DND: $e");
    }
  }

  Future<void> _enableDND() async {
    try {
      await FlutterDnd.setInterruptionFilter(
          FlutterDnd.INTERRUPTION_FILTER_NONE);
      setState(() {
        _dndEnabled = true;
      });
      debugPrint("DND enabled successfully.");
    } catch (e) {
      debugPrint("Error enabling DND: $e");
    }
  }

  Future<void> _disableDND() async {
    if (!_dndEnabled) return;

    try {
      await FlutterDnd.setInterruptionFilter(
          FlutterDnd.INTERRUPTION_FILTER_ALL);
      setState(() {
        _dndEnabled = false;
      });
      debugPrint("DND disabled successfully.");
    } catch (e) {
      debugPrint("Error disabling DND: $e");
    }
  }

  Future<void> _signin(BuildContext context) async {
    final url = Uri.parse('http://10.5.0.10:8000/validate-student/');
    final body = {
      'dob': dobController.text,
      'register_number': registerController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['message'] == 'Student matched successfully') {
          // Update the global ExamState
          final examState = Provider.of<ExamState>(context, listen: false);
          examState.updateRegNo(registerController.text);
          examState.updateExamId(responseData["examId"]);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ExamPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid Register Number or DOB")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.lightBlue.shade100, Colors.purple.shade100],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: registerController,
                  decoration: InputDecoration(
                    labelText: 'Register Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: dobController,
                  decoration: InputDecoration(
                    labelText: 'DOB (YYYY-MM-DD)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => _signin(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
