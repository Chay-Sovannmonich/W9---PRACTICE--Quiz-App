import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import 'circleNumber_widget.dart';
class QuestionResult extends StatelessWidget {
  final int questionNumber;
  final Answer answer;

  const QuestionResult({super.key, required this.questionNumber, required this.answer});

  Color get color => answer.isCorrect() ? Colors.green : Colors.red;

  bool isMatchedCorrectAnswer(int index) {
    return index == answer.question.correctAnswerIndex;
  }

  Color getChoiceColor(int index){
    if (isMatchedCorrectAnswer(index) && answer.selectedAnswerIndex == index) {
      return Colors.green;
    } else if(index == answer.selectedAnswerIndex && !answer.isCorrect()){
      return Colors.red;
    }else{
      return Colors.black;
    }
  }

  List<Widget> listChoices(){
    return answer.question.choices.asMap().entries.map((entry){
      int index = entry.key;
      String choice = entry.value;
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children : [
            isMatchedCorrectAnswer(index) ? const Icon(Icons.check, color: Colors.green) : const SizedBox(width: 24),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                choice,
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontSize: 16,
                  color: getChoiceColor(index),
                ),
              ),
            ),
          ]
        )
      );
    }).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children : [
              CircleNumber(number: questionNumber, color: color ),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  answer.question.title,
                  textAlign: TextAlign.center, 
                  style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ),
          ...listChoices(),
        ],
      ),
    );
  }
}