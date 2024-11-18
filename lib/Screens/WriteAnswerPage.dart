import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'PreviewPage.dart';
import 'package:http/http.dart' as http;

class WriteAnswerPage extends StatefulWidget {
  const WriteAnswerPage({Key? key}) : super(key: key);

  @override
  _WriteAnswerPageState createState() => _WriteAnswerPageState();
}

class _WriteAnswerPageState extends State<WriteAnswerPage> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  String _recognizedParagraph = ""; // Store the current paragraph
  bool _isLoading = false; // Loading state for the handwriting conversion
  Timer? _debounceTimer; // Timer for debounce
  final List<String> submittedAnswers = []; // List to store all submitted answers

  @override
  void initState() {
    super.initState();
    _signatureController.addListener(_onSignatureChange);
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSignatureChange() {
    if (_signatureController.isEmpty) return;

    // Cancel any existing debounce timers
    _debounceTimer?.cancel();

    // Start a new debounce timer
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _convertSignatureToText();
    });
  }

  Future<void> _convertSignatureToText() async {
    if (_signatureController.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final Uint8List? imageBytes = await _signatureController.toPngBytes();

    if (imageBytes == null || imageBytes.isEmpty) {
      setState(() {
        _isLoading = false;
        _recognizedParagraph = "Canvas is empty. Please write something.";
      });
      return;
    }

    final base64Image = base64Encode(imageBytes);
    final url = Uri.parse('http://10.5.0.6:8090/convert-to-text'); // Replace with your backend URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"image_base64": base64Image}),
      );

      if (response.statusCode == 200) {
        final recognizedText = jsonDecode(response.body)['text'];
        setState(() {
          if (_recognizedParagraph.isNotEmpty) {
            _recognizedParagraph += " "; // Add a space between sentences
          }
          _recognizedParagraph += recognizedText;
        });
      } else {
        setState(() {
          _recognizedParagraph = "Error: ${response.body}";
        });
      }
    } catch (e) {
      setState(() {
        _recognizedParagraph = "Error: $e";
      });
    }

    setState(() {
      _isLoading = false;
    });

    // Clear the signature pad after processing
    _signatureController.clear();
  }

  void _navigateToPreviewPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewPage(
          recognizedParagraph: _recognizedParagraph,
          submittedAnswers: submittedAnswers,
        ),
      ),
    );

    if (result == 'writeAgain') {
      setState(() {
        _recognizedParagraph = ""; // Clear the current paragraph for a new answer
      });
    } else if (result is String) {
      setState(() {
        _recognizedParagraph = result; // Update the paragraph with edited text
      });
    }
  }

  void _clearCanvas() {
    _signatureController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Write Answer",
          style: theme.textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services, color: Colors.red),
            tooltip: 'Clear Canvas',
            onPressed: _clearCanvas,
          ),
        ],
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Stack(
                        children: [
                          Signature(
                            controller: _signatureController,
                            width: double.infinity,
                            height: 600, // Fixed height for scrolling
                          ),
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: _recognizedParagraph.isEmpty
                            ? Center(
                                child: Text(
                                  "Converted text will appear here.",
                                  style: theme.textTheme.bodyLarge,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Text(
                                    _recognizedParagraph,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                ),
                              ),
                      ),
                      ElevatedButton(
                        onPressed: _recognizedParagraph.isEmpty ? null : _navigateToPreviewPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 600,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.primaryColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Stack(
                        children: [
                          Signature(
                            controller: _signatureController,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _recognizedParagraph.isEmpty
                          ? Center(
                              child: Text(
                                "Converted text will appear here.",
                                style: theme.textTheme.bodyLarge,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  _recognizedParagraph,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _recognizedParagraph.isEmpty ? null : _navigateToPreviewPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
