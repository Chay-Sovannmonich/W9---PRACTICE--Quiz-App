import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../widgets/questionResult_widget.dart';
import '../widgets/button_widget.dart';

class Result extends StatelessWidget {
  final VoidCallback restartQuiz;
  final VoidCallback switchScreen;
  final Quiz quiz;
  const Result({super.key, required this.quiz, required this.restartQuiz, required this.switchScreen});

  int get totalCorrectAnswers {
    int correctAnswers = 0;
    for (var answer in quiz.answers) {
      if (answer.isCorrect()) {
        correctAnswers++;
      }
    }
    return correctAnswers;
  }

  List<Widget> listQuestionResults() {
    return quiz.answers.asMap().entries.map((entry) {
      int index = entry.key;
      Answer answer = entry.value;
      return QuestionResult(questionNumber: index + 1, answer: answer);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Text(
                'You answered $totalCorrectAnswers out of ${quiz.questions.length}',
                style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'You get Score: ${quiz.calculateScore()}',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ...listQuestionResults(),
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                    text: 'Restart Quiz',
                    onPressed: restartQuiz,
                  ),
                  SizedBox(width: 20),
                  ButtonWidget(
                    text: 'View History',
                    onPressed: switchScreen,
                  ),
                ],
              ),
              SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}