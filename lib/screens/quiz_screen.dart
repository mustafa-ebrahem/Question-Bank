import 'package:flutter/material.dart';
import '../models/question.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String subjectName;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.subjectName,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Question> _randomizedQuestions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    // Randomize questions order
    _randomizedQuestions = List.from(widget.questions)..shuffle();
    // Randomize options for each question
    for (var question in _randomizedQuestions) {
      final originalOptions = List<String>.from(question.options);
      final originalCorrectAnswer = originalOptions[question.correctOptionIndex];
      originalOptions.shuffle();
      question.options = originalOptions;
      question.correctOptionIndex = originalOptions.indexOf(originalCorrectAnswer);
    }
  }

  void _checkAnswerAndProceed() {
    if (_selectedAnswer != null) {
      if (_selectedAnswer == _randomizedQuestions[_currentQuestionIndex].correctOptionIndex) {
        _score++;
      }

      setState(() {
        if (_currentQuestionIndex < _randomizedQuestions.length - 1) {
          _currentQuestionIndex++;
          _selectedAnswer = null;
        } else {
          _showResult = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.subjectName),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quiz Complete!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Text(
                'Your Score: $_score/${_randomizedQuestions.length}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Return to Subjects'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _randomizedQuestions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subjectName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _randomizedQuestions.length,
            ),
            const SizedBox(height: 20),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_randomizedQuestions.length}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion.questionText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ...currentQuestion.options.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswer == entry.key
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedAnswer = entry.key;
                    });
                  },
                  child: Text(entry.value),
                ),
              );
            }),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedAnswer == null ? null : _checkAnswerAndProceed,
              child: Text(
                _currentQuestionIndex < _randomizedQuestions.length - 1
                    ? 'Next Question'
                    : 'Finish Quiz',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
