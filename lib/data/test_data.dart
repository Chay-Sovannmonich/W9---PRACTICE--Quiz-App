import '../models/quiz_model.dart';
import '../models/shared_prefs_storage.dart';

List<Question> mockupQuestions = [
  Question(
    title: "What is the capital of France?",
    choices: ["Berlin", "Madrid", "Paris", "Rome"],
    correctAnswerIndex: 2,
    point: 10.0,
  ),
  Question(
    title: "What is the capital of Cambodia?",
    choices: ["Phnom Penh", "Bangkok", "Hanoi", "Vientiane"],
    correctAnswerIndex: 0,
    point: 10.0,
  ),
  Question(
    title: "Which planet is known as the Red Planet?",
    choices: ["Jupiter", "Venus", "Mars", "Saturn"],
    correctAnswerIndex: 2,
    point: 10.0,
  ),
];

Quiz initializeQuiz() {
  
  return Quiz(questions: mockupQuestions);
}

Quiz mockupQuiz = initializeQuiz();

Future<void> initializeQuestions() async {
  await SharedPrefsStorage.saveQuestions(mockupQuestions);
}