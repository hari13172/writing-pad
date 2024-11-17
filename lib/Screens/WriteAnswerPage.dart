import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
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

  String _recognizedText = "Your recognized text will appear here.";
  bool _isLoading = false; // Track loading state

  Future<void> _sendCanvasToBackend() async {
    if (_signatureController.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final Uint8List? imageBytes = await _signatureController.toPngBytes();

      if (imageBytes != null) {
        final base64Image = base64Encode(imageBytes);

        final url = Uri.parse('http://192.168.1.4:8090/convert-to-text');
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"image_base64": base64Image}),
        );

        if (response.statusCode == 200) {
          setState(() {
            _recognizedText = jsonDecode(response.body)['text'];
          });
        } else {
          setState(() {
            _recognizedText = "Error: Unable to recognize text.";
          });
        }
      }

      setState(() {
        _isLoading = false; // End loading
      });

      // Clear signature after 3 seconds
      Future.delayed(const Duration(seconds: 3), _clearSignature);
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  void _clearSignature() {
    _signatureController.clear();
    setState(() {
      _recognizedText = "Your recognized text will appear here.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handwriting to Text'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Signature(
                  controller: _signatureController,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearSignature,
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendCanvasToBackend,
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Convert to Text'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _recognizedText,
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
