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
  String selectedLanguage = 'hi-IN'; // Default language for translation

  final Map<String, String> languageMap = {
    'English': 'en-IN',
    'Hindi': 'hi-IN',
    'Tamil': 'ta-IN',
    'Malayalam': 'ml-IN',
    'Telugu': 'te-IN',
    'Marathi': 'mr-IN',
    'Kannada': 'kn-IN',
  };

  final Map<String, List<String>> questionWords = {
    'en-IN': [
      "what",
      "why",
      "how",
      "when",
      "where",
      "who",
      "Whom",
      "Whose",
      "Whatever",
      "Whatsoever",
      "Wherever",
      "Whenever",
      "Which",
      "Whichever",
      "However",
      "How much",
      "How many",
      "How often",
      "How long",
      "How far",
      "How old",
      "What is",
      "Why does",
      "How do",
      "Where can",
      "When will",
      "Which are"
    ],
    'hi-IN': [
      "कौन",
      "किस",
      "किसका",
      "किसकी",
      "किसके",
      "क्या",
      "कैसा",
      "कैसी",
      "कैसे",
      "कहाँ",
      "कहां से",
      "कहां तक",
      "कब",
      "कब से",
      "क्यों",
      "कौनसा",
      "कौनसी",
      "कौनसे",
      "कैसे",
      "कितना",
      "कितनी",
      "कितने",
      "कितनी बार",
      "कितने समय तक",
      "कितनी दूर",
      "कौन है",
      "क्या है",
      "क्यों नहीं",
      "कहाँ होगा",
      "किसने"
    ],
    'ta-IN': [
      "யார்",
      "எது",
      "என்ன",
      "எங்கு",
      "எங்கே",
      "எப்போது",
      "ஏன்",
      "எவ்வாறு",
      "எதற்கு",
      "எவன் / எவர்",
      "எவ்வளவு",
      "எத்தனை",
      "எதிலிருந்து",
      "எப்போது",
      "எதுவரை",
      "யார் தான்",
      "எப்படி இருக்கும்",
      "எவ்வளவு நேரம்",
      "எங்கே செல்கிறீர்கள்",
      "யாருடைய"
    ],
    'kn-IN': [
      "ಯಾರು",
      "ಏನು",
      "ಎಲ್ಲಿ",
      "ಎತ್ತೆ",
      "ಯಾವ",
      "ಯಾವುದು",
      "ಏಕೆ",
      "ಹೇಗೆ",
      "ಎಷ್ಟು",
      "ಎಷ್ಟಿನಷ್ಟು",
      "ಎಷ್ಟಷ್ಟು",
      "ಎಷ್ಟುಕಾಲ",
      "ಎಲ್ಲಿ ಬಂದವು",
      "ಯಾವಾಗ",
      "ಯಾವ ಕಡೆ",
      "ಯಾರೊಂದಿಗೆ",
      "ಏನು ಮಾಡಬಹುದು",
      "ಹೇಗೆ ನಡೀತೆ",
      "ಯಾರನ್ನು",
      "ಎಷ್ಟು ದಿನ"
    ],
    'mr-IN': [
      "कोण",
      "काय",
      "कुठे",
      "कोठे",
      "केव्हा",
      "कधी",
      "का",
      "कशासाठी",
      "कसे",
      "किती",
      "कोणाचे",
      "कुणाचा",
      "कुठपर्यंत",
      "कोठे आहे",
      "कधी होईल",
      "का नाही",
      "कोणत्या",
      "कसा दिसतो",
      "कोण तयार करतो",
      "कोणत्या प्रकारे"
    ],
    'te-IN': [
      "ఎవరు",
      "ఏమి",
      "ఎక్కడ",
      "ఎప్పుడు",
      "ఎందుకు",
      "ఎలా",
      "ఎవరి",
      "ఎవరికి",
      "ఎవరితో",
      "ఏది",
      "ఏంటి",
      "ఎన్ని",
      "ఎంత",
      "ఎక్కడికి",
      "ఎక్కడి నుంచి",
      "ఏంత",
      "ఎవరివరకు",
      "ఎవరితో ఉంటుంది",
      "ఎక్కడ ఉంటుంది",
      "ఏ సమయంలో"
    ]
  };

  final Map<String, List<String>> exclamatoryWords = {
    'en-IN': [
      "wow",
      "amazing",
      "great",
      "incredible",
      "stop",
      "hurry",
      "fantastic",
      "awesome",
      "unbelievable",
      "wonderful",
      "outstanding",
      "magnificent",
      "splendid",
      "marvelous",
      "brilliant"
    ],
    'hi-IN': [
      "वाह",
      "कमाल",
      "बहुत अच्छा",
      "रोको",
      "जल्दी",
      "शानदार",
      "अद्भुत",
      "बहुत बढ़िया",
      "अविश्वसनीय",
      "अद्वितीय",
      "जबरदस्त",
      "अत्युत्तम",
      "महान",
      "सर्वश्रेष्ठ",
      "प्रभावशाली"
    ],
    'ta-IN': [
      "அற்புதம்",
      "சூப்பர்",
      "நீங்கள் சாதித்தீர்கள்",
      "நிறுத்து",
      "அற்புதமான",
      "நன்றாக",
      "மிக சிறந்த",
      "அம்சமாய்",
      "அசத்தலான",
      "நிறுத்தி விடு",
      "சிறந்தது",
      "வியப்பான",
      "நன்றி",
      "மிகவும் அற்புதம்",
      "சிறந்த செயல்"
    ],
    'ml-IN': [
      "വാവ്",
      "അദ്ഭുതം",
      "നല്ലത്",
      "തുടരുക",
      "ശ്രദ്ധിക്കുക",
      "മികച",
      "വെറുതെ",
      "അത്യുത്തമ",
      "അമേയ്‌സിങ്",
      "ചെറുതല്ല",
      "വലിയ",
      "മികച്ച",
      "ആഹ്ലാദം",
      "സന്തോഷം",
      "ചെറിയ അല്ല"
    ],
    'mr-IN': [
      "वा",
      "अप्रतिम",
      "थांबा",
      "लवकर",
      "खूप छान",
      "अद्वितीय",
      "शानदार",
      "छान",
      "थक्क",
      "सर्वोत्तम",
      "अप्रतिम",
      "चांगले",
      "जबरदस्त",
      "प्रभावी",
      "उत्तम"
    ],
    'te-IN': [
      "అద్భుతం",
      "బాగుంది",
      "ఆపండి",
      "వేగంగా",
      "మంచిది",
      "అద్భుతమైనది",
      "గొప్ప",
      "చాలా బాగుంది",
      "అవిశ్వసనీయమైనది",
      "అత్యంత అద్భుతం",
      "సూపర్",
      "అద్భుత",
      "అద్భుతమైన పనితీరు",
      "ఉత్కృష్ట",
      "మంచి"
    ]
  };

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
              DropdownButton<String>(
                value: selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: languageMap.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.value,
                    child: Text(entry.key),
                  );
                }).toList(),
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
                String recognizedWords = result.recognizedWords.trim();
                if (_isQuestion(recognizedWords, selectedLanguage)) {
                  recognizedWords += "?";
                } else if (_isExclamation(recognizedWords)) {
                  recognizedWords += "!";
                } else {
                  recognizedWords += ",";
                }
                accumulatedText +=
                    (accumulatedText.isNotEmpty ? " " : "") + recognizedWords;
                _translateText();
              }
              confidence = result.confidence;
            });
          },
          localeId: selectedLanguage,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpeechSave(initialText: translatedText),
        ),
      );
    } else if (accumulatedText.isNotEmpty) {
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

  void _translateText() async {
    if (accumulatedText.isNotEmpty) {
      try {
        final translation = await translator.translate(
          accumulatedText,
          to: selectedLanguage.split('-')[0],
        );
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

  bool _isQuestion(String text, String language) {
    List<String>? words = questionWords[language];
    if (words == null) return false;
    for (String word in words) {
      if (text.toLowerCase().startsWith(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  bool _isExclamation(String text) {
    List<String> exclamatoryWords = [
      "wow",
      "amazing",
      "great",
      "incredible",
      "oh no",
      "stop",
      "hurry",
      "fantastic",
      "awesome"
    ];
    for (String word in exclamatoryWords) {
      if (text.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }
}
