import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ReviewPage.dart';

class PreviewPage extends StatefulWidget {
  final String recognizedParagraph;
  final List<String> submittedAnswers;
  final String docId;

  const PreviewPage({
    Key? key,
    required this.recognizedParagraph,
    required this.submittedAnswers,
    required this.docId,
  }) : super(key: key);

  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late String _editableParagraph;
  bool _isEditing = false;
  TextEditingController? _textController;

  @override
  void initState() {
    super.initState();
    _editableParagraph = widget.recognizedParagraph;
    _textController = TextEditingController(text: _editableParagraph);
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveEditing() {
    setState(() {
      _editableParagraph = _textController!.text;
      _isEditing = false;
    });

    saveAnswerToFirebase();
  }

  void _cancelEditing() {
    setState(() {
      _textController!.text = _editableParagraph;
      _isEditing = false;
    });
  }

  void _writeAgain() {
    Navigator.pop(context, 'writeAgain');
  }

  Future<void> saveAnswerToFirebase() async {
    const String endpoint = "http://10.5.0.10:8000/auth/write-answer/";
    final Map<String, dynamic> body = {
      "doc_id": widget.docId,
      "answer": _editableParagraph,
    };

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Answer saved successfully!")),
          );
          _navigateToReviewPage();
        } else {
          throw Exception(data['message'] ?? 'Unknown error occurred');
        }
      } else {
        throw Exception('Failed to save answer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  void _navigateToReviewPage() {
    // Check if the answer already exists in the submittedAnswers list
    final int existingIndex = widget.submittedAnswers.indexOf(widget.recognizedParagraph);

    if (existingIndex != -1) {
      // Update the existing answer
      widget.submittedAnswers[existingIndex] = _editableParagraph;
    } else {
      // Add the new answer
      widget.submittedAnswers.add(_editableParagraph);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          submittedAnswers: widget.submittedAnswers,
          docIds: [widget.docId], // Pass docIds to ReviewPage
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
          "Preview",
          style: theme.textTheme.displayLarge,
        ),
        actions: _isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveEditing, // Call _saveEditing on tick button press
                ),
                IconButton(
                  icon: const Icon(Icons.cancel),
                  onPressed: _cancelEditing,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: _isEditing
                    ? TextField(
                        controller: _textController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: theme.textTheme.bodyLarge,
                      )
                    : Text(
                        _editableParagraph,
                        style: theme.textTheme.bodyLarge,
                      ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_isEditing)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _startEditing,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Edit",
                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _writeAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Write Again",
                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: saveAnswerToFirebase,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
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
