import 'package:flutter/foundation.dart';
import '../models/subject.dart';

class SubjectsProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => [..._subjects];

  void addSubject(String name) {
    final subject = Subject(
      id: DateTime.now().toString(),
      name: name,
    );
    _subjects.add(subject);
    notifyListeners();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((subject) => subject.id == id);
    notifyListeners();
  }
}
