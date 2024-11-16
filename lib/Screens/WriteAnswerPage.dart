import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

class WriteAnswerPage extends StatefulWidget {
  @override
  _WriteAnswerPageState createState() => _WriteAnswerPageState();
}

class _WriteAnswerPageState extends State<WriteAnswerPage> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  String _recognizedText =
      "Your recognized text will appear here."; // Placeholder for recognized text

  Future<void> _recognizeHandwriting() async {
    if (_signatureController.isNotEmpty) {
      final Uint8List? imageBytes = await _signatureController.toPngBytes();

      if (imageBytes != null) {
        // Send the image to your backend
        final response = await http.post(
          Uri.parse("https://your-backend-endpoint/recognize"),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"image": base64Encode(imageBytes)}),
        );

        if (response.statusCode == 200) {
          setState(() {
            _recognizedText = json.decode(response.body)["text"];
          });
        } else {
          print("Error in recognition: ${response.body}");
        }
      }
    }
  }

  @override
  void dispose() {
    _signatureController.dispose(); // Dispose of the controller
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
        title: Text('Handwriting to Text'),
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
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _clearSignature,
                  child: Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: _recognizeHandwriting,
                  child: Text('Recognize Text'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _recognizedText,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
