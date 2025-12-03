import 'package:flutter/material.dart';
import 'ui/screen/welcome_screen.dart';
import 'ui/screen/question_screen.dart';
import 'data/test_data.dart';
import 'ui/screen/result_screen.dart';
import 'ui/screen/history_screen.dart';
import 'ui/screen/debug_screen.dart';
import 'models/shared_prefs_storage.dart';

enum AppScreen {
  welcome,
  quiz,
  result,
  history,
  debug,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SharedPrefsStorage.saveQuestions(mockupQuestions);
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppScreen currentScreen = AppScreen.welcome;

  void switchScreen(AppScreen screen) {
    setState(() {
      currentScreen = screen;
    });
  }

  void restartQuiz(){
    setState(() {
      currentScreen = AppScreen.welcome;
      mockupQuiz.resetQuiz();
    });
  }

  Widget get screenToShow {
    switch (currentScreen) {
      case AppScreen.welcome:
        return WelcomeScreen(switchScreen:() => switchScreen(AppScreen.quiz));
      case AppScreen.quiz:
        return QuestionScreen(quiz: mockupQuiz, switchScreen:() => switchScreen(AppScreen.result));
      case AppScreen.result:
        return Result(
          quiz: mockupQuiz, 
          restartQuiz: restartQuiz, 
          switchScreen:() => switchScreen(AppScreen.history)
        );
      case AppScreen.history:
        return HistoryScreen(quiz: mockupQuiz, restartQuiz: restartQuiz);
      case AppScreen.debug:
        return DebugScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          screenToShow,
          if (currentScreen != AppScreen.debug)
            Positioned(
              top: 40,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.black54,
                onPressed: () {
                  switchScreen(AppScreen.debug);
                },
                child: Icon(Icons.bug_report, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}