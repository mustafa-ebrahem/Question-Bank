import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/question_provider.dart';
import '../models/question.dart';
import 'add_question_dialog.dart';

class QuestionListScreen extends StatelessWidget {
  final String subjectId;
  final String subjectName;

  const QuestionListScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Questions: $subjectName',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Consumer<QuestionProvider>(
                    builder: (ctx, questionProvider, _) {
                      final questions = questionProvider.getQuestionsBySubject(subjectId);

                      if (questions.isEmpty) {
                        return const Center(
                          child: Text('No questions added yet'),
                        );
                      }

                      return ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (ctx, index) {
                          final question = questions[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ExpansionTile(
                              title: Text(question.questionText),
                              children: [
                                ...question.options.asMap().entries.map((entry) {
                                  return ListTile(
                                    leading: entry.key == question.correctOptionIndex
                                        ? const Icon(Icons.check, color: Colors.green)
                                        : const Icon(Icons.clear),
                                    title: Text(entry.value),
                                  );
                                }),
                                ButtonBar(
                                  children: [
                                    TextButton(
                                      onPressed: () => _deleteQuestion(context, question.id),
                                      child: const Text('Delete'),
                                    ),
                                    TextButton(
                                      onPressed: () => _editQuestion(context, question),
                                      child: const Text('Edit'),
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
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddQuestionDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
    );
  }

  void _showAddQuestionDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (ctx) => AddQuestionDialog(subjectId: subjectId),
    );

    if (result != null) {
      Provider.of<QuestionProvider>(context, listen: false).addQuestion(
        subjectId,
        result['questionText'],
        result['options'],
        result['correctOptionIndex'],
      );
    }
  }

  Future<void> _deleteQuestion(BuildContext context, String questionId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Provider.of<QuestionProvider>(context, listen: false)
          .deleteQuestion(questionId);
    }
  }

  void _editQuestion(BuildContext context, Question question) async {
    final questionController = TextEditingController(text: question.questionText);
    final optionControllers = question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    int selectedCorrectOption = question.correctOptionIndex;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Edit Question',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: questionController,
                  decoration: InputDecoration(
                    labelText: 'Question Text',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.help_outline),
                  ),
                  maxLines: 3,
                  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                Text(
                  'Options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: List.generate(4, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Radio<int>(
                                value: index,
                                groupValue: selectedCorrectOption,
                                onChanged: (value) {
                                  setState(() => selectedCorrectOption = value!);
                                },
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: optionControllers[index],
                                  decoration: InputDecoration(
                                    labelText: 'Option ${index + 1}',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  validator: (value) => 
                                      value?.isEmpty ?? true ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pop({
                            'questionText': questionController.text,
                            'options': optionControllers
                                .map((c) => c.text)
                                .toList(),
                            'correctOptionIndex': selectedCorrectOption,
                          });
                        }
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result != null) {
      final updatedQuestion = Question(
        id: question.id,
        subjectId: question.subjectId,
        questionText: result['questionText'],
        options: result['options'],
        correctOptionIndex: result['correctOptionIndex'],
      );
      Provider.of<QuestionProvider>(context, listen: false)
          .updateQuestion(updatedQuestion);
    }
  }
}
