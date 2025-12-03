import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback switchScreen;
  const WelcomeScreen({super.key, required this.switchScreen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Quiz App!',
              style: TextStyle(fontSize: 40, color: Colors.white,fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 90,
            ),
            SizedBox(
              height:300,
              child: Image.asset('assets/quiz-logo.png'),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              height:50,
              child: ElevatedButton(
                onPressed: () {
                  switchScreen();
                },
                child: const Text('Start Quiz'
                , style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}