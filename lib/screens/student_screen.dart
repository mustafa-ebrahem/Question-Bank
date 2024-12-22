import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects_provider.dart';
import '../providers/question_provider.dart';
import './quiz_screen.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<SubjectsProvider>(
        builder: (ctx, subjectsProvider, _) {
          final subjects = subjectsProvider.subjects;
          if (subjects.isEmpty) {
            return const Center(
              child: Text('No subjects available yet'),
            );
          }
          
          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (ctx, i) {
              final subject = subjects[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: Consumer<QuestionProvider>(
                  builder: (ctx, questionProvider, _) {
                    final questions = questionProvider.getQuestionsBySubject(subject.id);
                    return ListTile(
                      title: Text(subject.name),
                      subtitle: Text('${questions.length} questions'),
                      onTap: questions.isEmpty 
                        ? null 
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                  questions: questions,
                                  subjectName: subject.name,
                                ),
                              ),
                            );
                          },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
