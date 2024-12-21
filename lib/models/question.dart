class Question {
  final String id;
  final String subjectId;
  String questionText;
  List<String> options;
  int correctOptionIndex;

  Question({
    required this.id,
    required this.subjectId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      subjectId: json['subjectId'],
      questionText: json['questionText'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }
}
