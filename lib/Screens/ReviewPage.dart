import 'package:flutter/material.dart';
import 'PreviewPage.dart';

class ReviewPage extends StatelessWidget {
  final List<String> submittedAnswers;

  const ReviewPage({Key? key, required this.submittedAnswers}) : super(key: key);

  void _navigateToPreview(BuildContext context, String answer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewPage(
          recognizedParagraph: answer,
          submittedAnswers: submittedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Review Answers",
          style: theme.textTheme.displayLarge?.copyWith(color: Colors.black),
        ),
      ),
      body: submittedAnswers.isEmpty
          ? Center(
              child: Text(
                "No answers submitted yet.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.primaryColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: submittedAnswers.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: theme.cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.primaryColor,
                      child: Text(
                        "Q${index + 1}",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      submittedAnswers[index],
                      style: theme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      _navigateToPreview(context, submittedAnswers[index]);
                    },
                  ),
                );
              },
            ),
    );
  }
}
