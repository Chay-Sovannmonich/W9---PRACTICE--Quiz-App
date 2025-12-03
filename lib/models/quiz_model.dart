import 'shared_prefs_storage.dart';

class Quiz {
  final List<Question> questions;
  List<Answer> answers = [];
  double? _cachedScore; // Cache the score
  
  Quiz({required this.questions});
  
  void addAnswer(Answer answer) {
    answers.add(answer);
  }

  double calculateScore() {
    // Return cached score if already calculated
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
    
    // Save submission to shared preferences
    SharedPrefsStorage.saveSubmission(this);
    
    return totalScore;
  }

  void resetQuiz() {
    answers.clear();
    _cachedScore = null; // Clear cached score
  }

  // Get highest score from storage
  Future<double> get highestScore async {
    return await SharedPrefsStorage.getHighestScore();
  }
  
  // Get submission history from storage
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