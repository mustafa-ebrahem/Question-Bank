import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects_provider.dart';
import './subject_detail_screen.dart';

class TeacherScreen extends StatelessWidget {
  const TeacherScreen({super.key});

  void _addSubject(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Subject'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Subject Name',
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Provider.of<SubjectsProvider>(context, listen: false)
                  .addSubject(value);
              Navigator.of(ctx).pop();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
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
        builder: (ctx, subjectsProvider, _) => ListView.builder(
          itemCount: subjectsProvider.subjects.length,
          itemBuilder: (ctx, i) {
            final subject = subjectsProvider.subjects[i];
            return ListTile(
              title: Text(subject.name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => subjectsProvider.deleteSubject(subject.id),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSubject(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
