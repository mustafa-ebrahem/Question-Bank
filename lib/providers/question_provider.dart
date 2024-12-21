import 'package:flutter/foundation.dart';
import '../models/question.dart';

class QuestionProvider with ChangeNotifier {
  final List<Question> _questions = [];

  List<Question> getQuestionsBySubject(String subjectId) {
    return _questions.where((q) => q.subjectId == subjectId).toList();
  }

  void addQuestion(String subjectId, String questionText, List<String> options, int correctOptionIndex) {
    final question = Question(
      id: DateTime.now().toString(),
      subjectId: subjectId,
      questionText: questionText,
      options: options,
      correctOptionIndex: correctOptionIndex,
    );
    _questions.add(question);
    notifyListeners();
  }

  void updateQuestion(Question question) {
    final index = _questions.indexWhere((q) => q.id == question.id);
    if (index >= 0) {
      _questions[index] = question;
      notifyListeners();
    }
  }

  void deleteQuestion(String questionId) {
    _questions.removeWhere((q) => q.id == questionId);
    notifyListeners();
  }
}
