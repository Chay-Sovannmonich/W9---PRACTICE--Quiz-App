import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_model.dart';

class SharedPrefsStorage {
  static const String _questionsKey = 'quiz_app_questions';
  static const String _submissionsKey = 'quiz_app_submissions';
  static const String _highestScoreKey = 'quiz_app_highest_score';

  static SharedPreferences? _prefs;

  static Future<void> _init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // Save quiz questions
  static Future<void> saveQuestions(List<Question> questions) async {
    await _init();
    
    final questionsJson = questions.map((question) {
      return {
        'title': question.title,
        'choices': question.choices,
        'correctAnswerIndex': question.correctAnswerIndex,
        'point': question.point,
      };
    }).toList();
    
    final jsonString = jsonEncode(questionsJson);
    await _prefs!.setString(_questionsKey, jsonString);
    print('✅ Questions saved to shared preferences');
  }

  // Load quiz questions
  static Future<List<Question>> loadQuestions() async {
    await _init();
    
    final jsonString = _prefs!.getString(_questionsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> questionsJson = jsonDecode(jsonString);
        print('✅ Questions loaded from shared preferences');
        
        return questionsJson.map((json) {
          return Question(
            title: json['title'],
            choices: List<String>.from(json['choices']),
            correctAnswerIndex: json['correctAnswerIndex'],
            point: (json['point'] as num).toDouble(),
          );
        }).toList();
      } catch (e) {
        print('❌ Error parsing questions: $e');
      }
    }
    
    print('⚠️ No saved questions found');
    return [];
  }

  // Save quiz submission
  static Future<void> saveSubmission(Quiz quiz) async {
    await _init();
    
    final score = quiz.calculateScore();
    final answers = quiz.answers;
    
    final submission = {
      'timestamp': DateTime.now().toIso8601String(),
      'score': score,
      'answers': answers.map((answer) {
        return {
          'questionTitle': answer.question.title,
          'selectedAnswerIndex': answer.selectedAnswerIndex,
          'correctAnswerIndex': answer.question.correctAnswerIndex,
          'isCorrect': answer.isCorrect(),
        };
      }).toList(),
      'totalQuestions': quiz.questions.length,
      'correctAnswers': answers.where((a) => a.isCorrect()).length,
    };
    
    // Load existing submissions
    final existingJson = _prefs!.getString(_submissionsKey);
    List<Map<String, dynamic>> submissions = [];
    
    if (existingJson != null && existingJson.isNotEmpty) {
      try {
        submissions = List<Map<String, dynamic>>.from(jsonDecode(existingJson));
      } catch (e) {
        print('❌ Error parsing existing submissions: $e');
      }
    }
    
    submissions.add(submission);
    
    // Keep only last 10 submissions
    if (submissions.length > 10) {
      submissions = submissions.sublist(submissions.length - 10);
    }
    
    final jsonString = jsonEncode(submissions);
    await _prefs!.setString(_submissionsKey, jsonString);
    
    // Update highest score
    final currentHighest = _prefs!.getDouble(_highestScoreKey) ?? 0.0;
    if (score > currentHighest) {
      await _prefs!.setDouble(_highestScoreKey, score);
      print('🎉 New high score: $score');
    }
    
    print('✅ Submission saved. Score: $score');
  }

  // Load all submissions
  static Future<List<Map<String, dynamic>>> loadSubmissions() async {
    await _init();
    
    final jsonString = _prefs!.getString(_submissionsKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final submissions = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
        print('✅ Loaded ${submissions.length} submissions');
        return submissions;
      } catch (e) {
        print('❌ Error parsing submissions: $e');
      }
    }
    
    print('⚠️ No submissions found');
    return [];
  }

  // Get highest score
  static Future<double> getHighestScore() async {
    await _init();
    return _prefs!.getDouble(_highestScoreKey) ?? 0.0;
  }

  // Clear all data
  static Future<void> clearAllData() async {
    await _init();
    await _prefs!.remove(_questionsKey);
    await _prefs!.remove(_submissionsKey);
    await _prefs!.remove(_highestScoreKey);
    print('🗑️ Cleared all shared preferences data');
  }

  // Get all data for debugging
  static Future<Map<String, dynamic>> exportAllData() async {
    await _init();
    
    return {
      'questions': _prefs!.getString(_questionsKey),
      'submissions': _prefs!.getString(_submissionsKey),
      'highestScore': _prefs!.getDouble(_highestScoreKey) ?? 0.0,
      'keys': _prefs!.getKeys().toList(),
    };
  }
}