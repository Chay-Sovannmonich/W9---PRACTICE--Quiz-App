import 'shared_prefs_storage.dart';

class Quiz {
  final List<Question> questions;
  List<Answer> answers = [];
  double? _cachedScore; 
  
  Quiz({required this.questions});
  
  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  double calculateScore() {
    
    if (_cachedScore != null) {
      return _cachedScore!;
    }
    
    double totalScore = 0;
    for (var answer in answers) {
      if (answer.isCorrect()) {
        totalScore += answer.question.point;
      }
    }
    
    _cachedScore = totalScore;

    SharedPrefsStorage.saveSubmission(this);
    
    return totalScore;
  }

  void resetQuiz() {
    answers.clear();
    _cachedScore = null; 
  }

  Future<double> get highestScore async {
    return await SharedPrefsStorage.getHighestScore();
  }

  Future<List<Map<String, dynamic>>> getSubmissionHistory() async {
    return await SharedPrefsStorage.loadSubmissions();
  }
}


class Question {
  final String title;
  final List<String> choices;
  final int correctAnswerIndex;
  final double point;

  Question({
    required this.title,
    required this.choices,
    required this.correctAnswerIndex,
    required this.point,
  });
}

class Answer{
  final Question question;
  final int selectedAnswerIndex;

  Answer({
    required this.question,
    required this.selectedAnswerIndex,
  });

  bool isCorrect() {
    return question.correctAnswerIndex == selectedAnswerIndex;
  }
}