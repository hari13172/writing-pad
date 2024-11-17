import 'package:flutter/material.dart';
import '../models/UserData.dart';
import 'Signin.dart'; // Import Signin page
import 'ExamPage.dart'; // Import ExamPage

class Signup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController disabilityController = TextEditingController();
  final TextEditingController examModeController = TextEditingController();
  final TextEditingController registerNumberController =
      TextEditingController();

  Signup({super.key});

  void _saveUserData() {
    UserData user = UserData();
    user.name = nameController.text;
    user.collegeName = collegeController.text;
    user.dob = dobController.text;
    user.disabilityType = disabilityController.text;
    user.examMode = examModeController.text;
    user.registerNumber = registerNumberController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/logo.png',
            height: 40,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Detail Form',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: collegeController,
                decoration: InputDecoration(
                  labelText: 'College Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: dobController,
                decoration: InputDecoration(
                  labelText: 'DOB',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: disabilityController,
                decoration: InputDecoration(
                  labelText: 'Disability Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: examModeController,
                decoration: InputDecoration(
                  labelText: 'Exam Mode',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: registerNumberController,
                decoration: InputDecoration(
                  labelText: 'Register Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveUserData(); // Save user data without password
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Signin()), // Navigate to Signin page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ExamPage()), // Navigate to ExamPage
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Go to Exam Page',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
