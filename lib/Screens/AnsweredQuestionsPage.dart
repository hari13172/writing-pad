import 'package:flutter/material.dart';

class AnsweredQuestionsPage extends StatelessWidget {
  final int totalQuestions;
  final int completedQuestions;

  AnsweredQuestionsPage({
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Answered Questions',
          style: TextStyle(color: Colors.deepPurple),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.deepPurple),
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
            Text(
              'Review Answered and Unanswered Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: questionStatus,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
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
