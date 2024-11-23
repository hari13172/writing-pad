import 'package:flutter/material.dart';
import 'package:new_app/Screens/DonePage.dart';
import 'PreviewPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<String> questions = [];
  List<String> submittedAnswers = [];
  List<String> docIds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExamQuestionsAndAnswers();
  }

  Future<void> fetchExamQuestionsAndAnswers() async {
    const String endpoint =
        "http://10.5.0.10:8000/auth/get-exam-questions-answer/";
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final questionsData = data['data'] as List;
          setState(() {
            docIds = questionsData.map((q) => q['id'].toString()).toList();
            questions =
                questionsData.map((q) => q['question'].toString()).toList();
            submittedAnswers =
                questionsData.map((q) => q['answer'].toString()).toList();
            isLoading = false;
          });
        } else {
          throw Exception(
              data['message'] ?? 'Unexpected response from the server.');
        }
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  void _navigateToPreview(
      BuildContext context, String answer, String question, String docId) {
    final currentIndex = docIds.indexOf(docId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewPage(
          recognizedParagraph: answer.isEmpty ? question : answer,
          submittedAnswers: submittedAnswers,
          docId: docId,
          currentIndex: currentIndex,
          totalIndex: docIds.length,
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
          style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : questions.isEmpty
                    ? Center(
                        child: Text(
                          "No questions available.",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final isAnswerFilled =
                              index < submittedAnswers.length &&
                                  submittedAnswers[index].isNotEmpty;

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
                                questions[index],
                                style: theme.textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                "Answer: ${submittedAnswers[index].isNotEmpty ? submittedAnswers[index] : "No answer provided"}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: submittedAnswers[index].isNotEmpty
                                      ? Colors.black
                                      : Colors.red,
                                ),
                              ),
                              trailing: Icon(
                                isAnswerFilled
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color:
                                    isAnswerFilled ? Colors.green : Colors.red,
                              ),
                              onTap: () {
                                final answer = index < submittedAnswers.length
                                    ? submittedAnswers[index]
                                    : "";

                                _navigateToPreview(context, answer,
                                    questions[index], docIds[index]);
                              },
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 32.0,
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
