import 'package:flutter/material.dart';

class ChoiceButton extends StatelessWidget {
  final String answerText;
  final VoidCallback onTap;

  const ChoiceButton({super.key, required this.answerText, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          answerText,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}