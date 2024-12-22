import 'package:flutter/foundation.dart';
import '../models/subject.dart';

class SubjectsProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => [..._subjects];

  Future<void> addSubject(String name, String category) async {
    final subject = Subject(
      id: DateTime.now().toString(),
      name: name,
      category: category,
    );
    _subjects.add(subject);
    notifyListeners();
  }

  List<String> get categories {
    return _subjects
        .map((subject) => subject.category)
        .toSet()
        .toList();
  }

  List<Subject> getSubjectsByCategory(String category) {
    return _subjects.where((subject) => subject.category == category).toList();
  }

  Future<void> deleteSubject(String id) async {
    _subjects.removeWhere((subject) => subject.id == id);
    notifyListeners();
  }

  Future<void> updateSubject(String id, String newName, String category) async {
    final index = _subjects.indexWhere((subject) => subject.id == id);
    if (index != -1) {
      _subjects[index] = Subject(
        id: id,
        name: newName,
        category: category,
      );
      notifyListeners();
    }
  }

  // Get unique categories
  List<String> get uniqueCategories {
    return _subjects.map((subject) => subject.category).toSet().toList()
      ..sort();
  }
}
