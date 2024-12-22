import 'package:flutter/foundation.dart';
import '../models/question.dart';

class QuestionProvider with ChangeNotifier {
  final List<Question> _questions = [];

  List<Question> getQuestionsBySubject(String subjectId) {
    return _questions.where((question) => question.subjectId == subjectId).toList();
  }

  Future<void> addQuestion(String subjectId, String questionText, List<String> options, int correctOptionIndex) async {
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

  Future<void> updateQuestion(Question question) async {
    final index = _questions.indexWhere((q) => q.id == question.id);
    if (index != -1) {
      _questions[index] = question;
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    _questions.removeWhere((question) => question.id == questionId);
    notifyListeners();
  }
}
