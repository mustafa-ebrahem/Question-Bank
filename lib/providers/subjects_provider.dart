import 'package:flutter/foundation.dart';
import '../models/subject.dart';

class SubjectsProvider with ChangeNotifier {
  final List<Subject> _subjects = [];

  List<Subject> get subjects => [..._subjects];

  Future<void> addSubject(String name) async {
    final subject = Subject(
      id: DateTime.now().toString(),
      name: name,
    );
    _subjects.add(subject);
    notifyListeners();
  }

  Future<void> deleteSubject(String id) async {
    _subjects.removeWhere((subject) => subject.id == id);
    notifyListeners();
  }

  Future<void> updateSubject(String id, String newName) async {
    final index = _subjects.indexWhere((subject) => subject.id == id);
    if (index != -1) {
      _subjects[index] = Subject(
        id: id,
        name: newName,
      );
      notifyListeners();
    }
  }
}
