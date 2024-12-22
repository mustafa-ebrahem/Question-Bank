import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects_provider.dart';
import '../providers/question_provider.dart';
import './subject_detail_screen.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  Future<void> _showAddSubjectDialog(BuildContext context) async {
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Subject'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: textController,
            decoration: const InputDecoration(
              labelText: 'Subject Name',
              hintText: 'Enter subject name',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject name';
              }
              return null;
            },
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Provider.of<SubjectsProvider>(context, listen: false)
                    .addSubject(textController.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context, String subjectId, String currentName) async {
    final textController = TextEditingController(text: currentName);
    
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Subject'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                Provider.of<SubjectsProvider>(context, listen: false)
                    .updateSubject(subjectId, textController.text);
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
        title: const Text('Teacher Dashboard'),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditDialog(context, subject.id, subject.name),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => subjectsProvider.deleteSubject(subject.id),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubjectDetailScreen(subject: subject),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubjectDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
