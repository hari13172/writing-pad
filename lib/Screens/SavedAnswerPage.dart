import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedAnswerPage extends StatefulWidget {
  final String answer;

  const SavedAnswerPage({Key? key, required this.answer}) : super(key: key);

  @override
  _SavedAnswerPageState createState() => _SavedAnswerPageState();
}

class _SavedAnswerPageState extends State<SavedAnswerPage> {
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _saveAnswerAsTextFile();
  }

  Future<void> _saveAnswerAsTextFile() async {
    try {
      // Get the directory to save the file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/question1_answer.txt');

      // Write the answer to the file
      await file.writeAsString(widget.answer);

      setState(() {
        _filePath = file.path; // Store the file path
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Answer saved at ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error saving file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save answer: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Answer"),
      ),
      body: _filePath == null
          ? const Center(child: CircularProgressIndicator()) // Show loading until the file is saved
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Answer saved at:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _filePath!,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Answer Content:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.answer,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
