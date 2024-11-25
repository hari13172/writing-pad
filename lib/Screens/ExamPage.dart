import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'WriteAnswerPage.dart';
import 'speech_to_text.dart';

// ignore: must_be_immutable
class ExamPage extends StatefulWidget {
  int currentIndex;
  int totalIndex;

  ExamPage({Key? key, this.currentIndex = 0, this.totalIndex = 0})
      : super(key: key);

  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  List<Map<String, dynamic>> questions = [];
  int _secondsElapsed = 0;
  Timer? _timer;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchQuestions() async {
    const String baseUrl = "http://10.5.0.10:8000/get-exam-questions";
    const String studentId = "12345";
    const String sessionId = "95879983-4e74-4cd0-b980-f66c08c30b52";

    final String endpoint = "$baseUrl/$studentId/$sessionId/";

    try {
      final response = await http.get(Uri.parse(endpoint));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success' && data['questions'] != null) {
          setState(() {
            questions =
                List<Map<String, dynamic>>.from(data['questions'].map((q) => {
                      'id': q['id'] ?? 'Unknown ID',
                      'question': q['text'] ?? 'No question text available',
                    }));
            isLoading = false;
          });
        } else {
          setState(() {
            hasError = true;
            errorMessage = data['message'] ?? 'Unexpected response format.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          errorMessage =
              'Server returned an error. Status Code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        hasError = true;
        errorMessage = 'Failed to connect to the server. Error: $e';
        isLoading = false;
      });
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  String getFormattedTime() {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  void _nextQuestion() {
    if (widget.currentIndex < questions.length - 1) {
      setState(() {
        widget.currentIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Exam Complete"),
          content: const Text("You have completed all questions."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  double _getProgressValue() {
    return questions.isEmpty
        ? 0.0
        : (widget.currentIndex + 1) / questions.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.png'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.deepPurple),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Failed to load questions.',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        errorMessage,
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: fetchQuestions,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _getProgressValue(),
                        backgroundColor: theme.colorScheme.surface,
                        color: theme.primaryColor,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Time: ${getFormattedTime()}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Question ${widget.currentIndex + 1}/${questions.length}:',
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        questions.isNotEmpty
                            ? (questions[widget.currentIndex]["question"] ??
                                "No question available")
                            : "No question available",
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WriteAnswerPage(
                                    id: questions[widget.currentIndex]["id"],
                                    currentIndex: widget.currentIndex,
                                    totalIndex: questions.length,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.white),
                            label: const Text(
                              'WRITE',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SpeechText(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.mic, color: Colors.white),
                            label: const Text(
                              'SPEAK',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (widget.currentIndex > 0) {
                                setState(() {
                                  widget.currentIndex--;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Terminate Exam"),
                                    content: const Text(
                                        "Are you sure you want to terminate the exam?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          Navigator.of(context)
                                              .pushReplacementNamed('/');
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'BACK',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _nextQuestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'NEXT',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
