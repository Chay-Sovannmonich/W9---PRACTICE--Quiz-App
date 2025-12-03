import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import 'choiceButton_widget.dart';

class QuestionWidget extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback toNextQuestion;
  final Question question;

  const QuestionWidget({super.key, required this.question, required this.toNextQuestion, required this.quiz});

  void getPlayerChoiceIndex(int index, Question question) {
    print('Player selected index $index for question: ${question.title}');
    print('Correct answer index: ${question.correctAnswerIndex}');
    print('Choice selected: ${question.choices[index]}');
    
    Answer answer = Answer(question: question, selectedAnswerIndex: index);
    quiz.addAnswer(answer);
    
    print('Total answers in quiz: ${quiz.answers.length}');
    
    toNextQuestion();
  }

  List<Widget> listChoiceButtons(){
    return question.choices.asMap().entries.map((entry) {
      int index = entry.key;
      String choice = entry.value;
      return Container(
        margin : EdgeInsets.only(bottom: 30),
        child: ChoiceButton(
          answerText: choice,
          onTap: () => getPlayerChoiceIndex(index, question),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children : [
          SizedBox(height: 100),
          Text(question.title, style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),),
          SizedBox(height: 40),
          ...listChoiceButtons(),
        ]
      ),
    );
  }
}