import 'package:flutter/foundation.dart';

class ExamState with ChangeNotifier {
  String regNo = '';
  String examId = '';

  void updateRegNo(String newRegNo) {
    regNo = newRegNo;
    notifyListeners();
  }

  void updateExamId(String newExamId) {
    examId = newExamId;
    notifyListeners();
  }
}
