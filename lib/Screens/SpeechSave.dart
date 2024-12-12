import 'package:flutter/material.dart';
import 'speechreviewpage.dart'; // Import the SpeechReviewPage

class SpeechSave extends StatefulWidget {
  final String initialText; // Initial text passed from SpeechText page

  const SpeechSave({Key? key, required this.initialText}) : super(key: key);

  @override
  State<SpeechSave> createState() => _SpeechSaveState();
}

class _SpeechSaveState extends State<SpeechSave> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveAnswer() {
    final savedText = _textController.text; // Get the saved text
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SpeechReviewPage(
          question: "q1", // Example question identifier
          answer: savedText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit and Save Answer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Edit your answer here...",
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAnswer,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Save Answer",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
