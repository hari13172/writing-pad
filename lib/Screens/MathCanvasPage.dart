import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:new_app/Screens/MathSavePage.dart';

class MathCanvasPage extends StatefulWidget {
  @override
  _MathCanvasPageState createState() => _MathCanvasPageState();
}

class _MathCanvasPageState extends State<MathCanvasPage> {
  final List<Offset> _points = [];
  String? _calculatorResult;
  final GlobalKey _canvasKey = GlobalKey();
  bool _isEraserMode = false;

  void _clearCanvas() {
    setState(() {
      _points.clear();
    });
  }

  void _toggleEraserMode() {
    setState(() {
      _isEraserMode = !_isEraserMode;
    });
  }

  void _showCalculatorResult(String result) {
    setState(() {
      _calculatorResult = result;
    });

    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _calculatorResult = null;
        });
      }
    });
  }

  Future<void> _submitCanvas() async {
    try {
      // Capture the canvas as an image
      RenderRepaintBoundary boundary = _canvasKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List imageData = byteData!.buffer.asUint8List();

      // Navigate to the save page with the image data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MathSavePage(
            imageData: imageData,
            points: const [],
            output: '',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture canvas: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Canvas'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _CalculatorPopup(
                  onResult: _showCalculatorResult,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_calculatorResult != null)
            Container(
              width: double.infinity,
              color: Colors.yellow[100],
              padding: const EdgeInsets.all(10),
              child: Text(
                'Result: $_calculatorResult',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 10),
          const Text(
            'Canvas Area',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.6, // 50vh equivalent
              child: RepaintBoundary(
                key: _canvasKey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox box = context.findRenderObject() as RenderBox;
                        Offset localPosition =
                            box.globalToLocal(details.localPosition);
                        if (_isEraserMode) {
                          _points.removeWhere(
                              (point) => (point - localPosition).distance < 20);
                        } else {
                          _points.add(localPosition);
                        }
                      });
                    },
                    onPanEnd: (details) {
                      if (!_isEraserMode) {
                        _points.add(Offset.zero);
                      }
                    },
                    child: CustomPaint(
                      painter: _CanvasPainter(_points),
                      child: Container(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _clearCanvas,
                    child: const Text('Clear Canvas'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _toggleEraserMode,
                    child: Text(
                        _isEraserMode ? 'Switch to Pen' : 'Switch to Eraser'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEraserMode ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitCanvas,
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final List<Offset> points;

  _CanvasPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _CalculatorPopup extends StatefulWidget {
  final Function(String result) onResult;

  _CalculatorPopup({required this.onResult});

  @override
  State<_CalculatorPopup> createState() => _CalculatorPopupState();
}

class _CalculatorPopupState extends State<_CalculatorPopup> {
  String _expression = "";
  String _result = "0";

  void _calculateResult() {
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(_expression);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);

      setState(() {
        _result = eval.toString();
      });
    } catch (e) {
      setState(() {
        _result = "Error";
      });
    }
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "=") {
        _calculateResult();
      } else if (value == "C") {
        _expression = "";
        _result = "0";
      } else {
        _expression += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Calculator'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _expression,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
            const Divider(),
            _buildCalculator(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onResult(_result); // Pass the result back to the parent
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildCalculator() {
    return Column(
      children: [
        _buildButtonRow(["7", "8", "9", "/"]),
        _buildButtonRow(["4", "5", "6", "*"]),
        _buildButtonRow(["1", "2", "3", "-"]),
        _buildButtonRow(["C", "0", "=", "+"]),
      ],
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((label) => ElevatedButton(
                onPressed: () => _onButtonPressed(label),
                child: Text(label),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(50, 50),
                  backgroundColor: Colors.orangeAccent,
                ),
              ))
          .toList(),
    );
  }
}
