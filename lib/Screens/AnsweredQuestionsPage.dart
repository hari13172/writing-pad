import 'package:flutter/material.dart';

class AnsweredQuestionsPage extends StatelessWidget {
  final int totalQuestions;
  final int completedQuestions;

  const AnsweredQuestionsPage({super.key, 
    required this.totalQuestions,
    required this.completedQuestions,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> questionStatus = [];

    // Build list of question status indicators
    for (int i = 1; i <= totalQuestions; i++) {
      bool isCompleted = i <= completedQuestions;
      questionStatus.add(
        CircleAvatar(
          radius: 20,
          backgroundColor: isCompleted ? Colors.green : Colors.red,
          child: Text(
            '$i',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Answered Questions',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.deepPurple),
            onPressed: () {
              // Add proctoring video action here if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Review Answered and Unanswered Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: questionStatus,
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
