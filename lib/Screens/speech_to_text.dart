import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:new_app/Screens/SpeechSave.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class SpeechText extends StatefulWidget {
  const SpeechText(
      {Key? key, required Null Function(dynamic String) onSaveText})
      : super(key: key);

  @override
  State<SpeechText> createState() => _SpeechTextState();
}

class _SpeechTextState extends State<SpeechText> {
  bool isListening = false;
  late stt.SpeechToText _speechToText;
  String accumulatedText = ""; // Stores all recognized text
  String translatedText = ""; // Stores translated text
  double confidence = 1.0; // Confidence percentage
  final translator = GoogleTranslator(); // Translator instance

  @override
  void initState() {
    _speechToText = stt.SpeechToText();
    super.initState();
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speech to Text"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.blue,
        duration: const Duration(milliseconds: 1000),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: isListening ? Colors.green : Colors.blue,
          onPressed: _toggleListening,
          child: Icon(
            isListening ? Icons.mic : Icons.mic_none,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                accumulatedText.isNotEmpty
                    ? accumulatedText
                    : "Press the mic and start speaking...",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                translatedText.isNotEmpty
                    ? translatedText
                    : "Translation will appear here...",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.translate, color: Colors.orange),
                        onPressed: () => _translateText('hi'),
                        tooltip: "Translate to Hindi",
                      ),
                      const Text(
                        "Hindi",
                        style: TextStyle(fontSize: 14, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.translate, color: Colors.green),
                        onPressed: () => _translateText('ta'),
                        tooltip: "Translate to Tamil",
                      ),
                      const Text(
                        "Tamil",
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _submitText,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _toggleListening() async {
    if (!isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == "notListening") {
            setState(() => isListening = false);
          }
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${error.errorMsg}")),
          );
          setState(() => isListening = false);
        },
      );

      if (available) {
        setState(() => isListening = true);
        _speechToText.listen(
          onResult: (result) {
            setState(() {
              if (result.finalResult) {
                accumulatedText += (accumulatedText.isNotEmpty ? " " : "") +
                    result.recognizedWords;
              }
              confidence = result.confidence; // Update confidence value
            });
          },
          listenMode: stt.ListenMode.dictation,
          partialResults: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Speech recognition not available.")),
        );
      }
    } else {
      setState(() => isListening = false);
      _speechToText.stop();
    }
  }

  void _submitText() {
    if (translatedText.isNotEmpty) {
      // Pass the translated text if available
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeechSave(initialText: translatedText),
        ),
      );
    } else if (accumulatedText.isNotEmpty) {
      // Fallback to the original accumulated text
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeechSave(initialText: accumulatedText),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No text to submit! Please speak first.")),
      );
    }
  }

  void _translateText(String targetLanguage) async {
    if (accumulatedText.isNotEmpty) {
      try {
        final translation =
            await translator.translate(accumulatedText, to: targetLanguage);
        setState(() => translatedText = translation.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Translation Error: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("No text to translate! Please speak first.")),
      );
    }
  }
}
