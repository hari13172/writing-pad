import 'package:flutter/material.dart';
import 'ReviewPage.dart';

class PreviewPage extends StatefulWidget {
  final String recognizedParagraph;
  final List<String> submittedAnswers; // List to store submitted answers

  const PreviewPage({
    Key? key,
    required this.recognizedParagraph,
    required this.submittedAnswers,
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
    Navigator.pop(context, _editableParagraph); // Pass the updated text back
  }

  void _cancelEditing() {
    setState(() {
      _textController!.text = _editableParagraph;
      _isEditing = false;
    });
  }

  void _writeAgain() {
    Navigator.pop(context, 'writeAgain'); // Signal to write again
  }

  void _navigateToReviewPage() {
    // Add the submitted answer to the list and navigate to ReviewPage
    if (!widget.submittedAnswers.contains(_editableParagraph)) {
      widget.submittedAnswers.add(_editableParagraph);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewPage(
          submittedAnswers: widget.submittedAnswers,
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
                  onPressed: _saveEditing,
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
              height: 200, // Fixed height for the container
              width: double.infinity, // Full width
              decoration: BoxDecoration(
                border: Border.all(color: theme.primaryColor, width: 2), // Border around text
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              padding: const EdgeInsets.all(16.0), // Padding inside the border
              child: SingleChildScrollView(
                child: _isEditing
                    ? TextField(
                        controller: _textController,
                        maxLines: null, // Allows multiline editing
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Removes default TextField border
                        ),
                        style: theme.textTheme.bodyLarge, // Use global text style
                      )
                    : Text(
                        _editableParagraph,
                        style: theme.textTheme.bodyLarge, // Use global text style
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
                      backgroundColor: Colors.red, // Highlight Write Again button in red
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
                    onPressed: _navigateToReviewPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Highlight Save button in green
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
