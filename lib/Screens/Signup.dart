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
    final theme = Theme.of(context); // Access the current theme

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
              Text(
                'Student Detail Form',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.deepPurple, // Adjust color if needed
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: nameController,
                label: 'Name',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: collegeController,
                label: 'College Name',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: dobController,
                label: 'DOB',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: disabilityController,
                label: 'Disability Type',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: examModeController,
                label: 'Exam Mode',
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: registerNumberController,
                label: 'Register Number',
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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

  // Helper function to build a styled TextField
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.labelLarge, // Use global label style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
