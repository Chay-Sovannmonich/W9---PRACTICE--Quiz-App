import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../widgets/questionView_widget.dart';

class QuestionScreen extends StatefulWidget {
  final VoidCallback switchScreen;
  final Quiz quiz;
  const QuestionScreen({super.key, required this.quiz, required this.switchScreen});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int currentQuestionIndex = 0;

  void toNextQuestion() {
    print('Moving from question $currentQuestionIndex to ${currentQuestionIndex + 1}');
    print('Total questions: ${widget.quiz.questions.length}');
    print('Answers so far: ${widget.quiz.answers.length}');
    
    setState(() {
      currentQuestionIndex++;
    });

    if (currentQuestionIndex >= widget.quiz.questions.length) {
      print('All questions answered, switching to result screen');
      widget.switchScreen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    print('Building QuestionScreen with index: $currentQuestionIndex');
    
    // Safety check
    if (currentQuestionIndex >= widget.quiz.questions.length) {
      print('Index out of bounds, switching to result screen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.switchScreen();
      });
      return Scaffold(
        backgroundColor: Colors.blue,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.blue,
      body: QuestionWidget(
        question: widget.quiz.questions[currentQuestionIndex],
        toNextQuestion: toNextQuestion,
        quiz: widget.quiz,
      ),
    );
  }
}