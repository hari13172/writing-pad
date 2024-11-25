import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'Signin.dart';
import 'ExamPage.dart';

class Signup extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController collegeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController disabilityController = TextEditingController();
  final TextEditingController examModeController = TextEditingController();
  final TextEditingController registerNumberController =
      TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Signup({super.key});

  Future<void> _submitForm(BuildContext context) async {
    final url = Uri.parse('http://10.5.0.10:8000/submit-student-form/');
    final body = {
      'name': nameController.text,
      'college_name': collegeController.text,
      'dob': dobController.text,
      'disability_type': disabilityController.text,
      'exam_mode': examModeController.text,
      'register_number': registerNumberController.text,
      'contact_number': contactNumberController.text,
      'email': emailController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student registered successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Signin()), // Navigate to Signin page
        );
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
    final theme = Theme.of(context);

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
                  color: Colors.deepPurple,
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
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: contactNumberController,
                label: 'Contact Number',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                context,
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _submitForm(context), // Submit the form
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
                        builder: (context) => ExamPage(
                          currentIndex: 0,
                          totalIndex: 0,
                        ),
                      ),
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
        labelStyle: theme.textTheme.labelLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
    );
  }
}
