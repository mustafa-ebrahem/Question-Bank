import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/subject.dart';
import '../models/question.dart';
import '../providers/question_provider.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
  });

  void _addQuestion(BuildContext context) {
    final questionTextController = TextEditingController();
    final optionsControllers = List.generate(4, (_) => TextEditingController());
    int selectedCorrectOption = 0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Question'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionTextController,
                decoration: const InputDecoration(labelText: 'Question Text'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              ...List.generate(4, (index) {
                return Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: selectedCorrectOption,
                      onChanged: (value) {
                        selectedCorrectOption = value!;
                        (ctx as Element).markNeedsBuild();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionsControllers[index],
                        decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (questionTextController.text.isNotEmpty &&
                  optionsControllers.every((controller) => controller.text.isNotEmpty)) {
                Provider.of<QuestionProvider>(context, listen: false).addQuestion(
                  subject.id,
                  questionTextController.text,
                  optionsControllers.map((c) => c.text).toList(),
                  selectedCorrectOption,
                );
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editQuestion(BuildContext context, Question question) {
    final questionTextController = TextEditingController(text: question.questionText);
    final optionsControllers = question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    var selectedCorrectOption = question.correctOptionIndex;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Question'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionTextController,
                decoration: const InputDecoration(labelText: 'Question Text'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              ...List.generate(4, (index) {
                return Row(
                  children: [
                    Radio<int>(
                      value: index,
                      groupValue: selectedCorrectOption,
                      onChanged: (value) {
                        selectedCorrectOption = value!;
                        (ctx as Element).markNeedsBuild();
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: optionsControllers[index],
                        decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (questionTextController.text.isNotEmpty &&
                  optionsControllers.every((controller) => controller.text.isNotEmpty)) {
                final updatedQuestion = Question(
                  id: question.id,
                  subjectId: question.subjectId,
                  questionText: questionTextController.text,
                  options: optionsControllers.map((c) => c.text).toList(),
                  correctOptionIndex: selectedCorrectOption,
                );
                Provider.of<QuestionProvider>(context, listen: false)
                    .updateQuestion(updatedQuestion);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<QuestionProvider>(
        builder: (ctx, questionProvider, _) {
          final questions = questionProvider.getQuestionsBySubject(subject.id);
          return questions.isEmpty
              ? const Center(child: Text('No questions added yet'))
              : ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (ctx, index) {
                    final question = questions[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ExpansionTile(
                        title: Text(question.questionText),
                        children: [
                          ...question.options.asMap().entries.map((entry) {
                            final isCorrect = entry.key == question.correctOptionIndex;
                            return ListTile(
                              leading: Icon(
                                isCorrect ? Icons.check_circle : Icons.circle_outlined,
                                color: isCorrect ? Colors.green : null,
                              ),
                              title: Text(entry.value),
                            );
                          }),
                          OverflowBar(
                            spacing: 8,
                            alignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => _editQuestion(context, question),
                                child: const Text('Edit'),
                              ),
                              TextButton(
                                onPressed: () => Provider.of<QuestionProvider>(context, listen: false)
                                    .deleteQuestion(question.id),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addQuestion(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
