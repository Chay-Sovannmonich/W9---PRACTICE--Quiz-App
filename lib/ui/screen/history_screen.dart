import 'package:flutter/material.dart';
import '../../models/quiz_model.dart';
import '../widgets/button_widget.dart';

class HistoryScreen extends StatefulWidget {
  final VoidCallback restartQuiz;
  final Quiz quiz;
  const HistoryScreen({super.key, required this.quiz, required this.restartQuiz});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> submissions = [];
  double highestScore = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedSubmissions = await widget.quiz.getSubmissionHistory();
    final loadedHighestScore = await widget.quiz.highestScore;
    
    setState(() {
      submissions = loadedSubmissions;
      highestScore = loadedHighestScore;
      isLoading = false;
    });
  }

  Widget _buildSubmissionTile(Map<String, dynamic> submission, int index) {
    final timestamp = DateTime.parse(submission['timestamp']);
    final score = submission['score'] as double;
    final correctAnswers = submission['correctAnswers'];
    final totalQuestions = submission['totalQuestions'];
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getScoreColor(score),
          child: Text('${index + 1}', style: TextStyle(color: Colors.white)),
        ),
        title: Text(
          'Score: $score',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getScoreColor(score),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$correctAnswers/$totalQuestions correct'),
            Text(
              '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          _showSubmissionDetails(submission);
        },
      ),
    );
  }

  Color _getScoreColor(double score) {
    final maxScore = widget.quiz.questions.length * 10.0;
    final percentage = score / maxScore;
    
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.orange;
    return Colors.red;
  }

  void _showSubmissionDetails(Map<String, dynamic> submission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Quiz Results Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Score: ${submission['score']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Date: ${DateTime.parse(submission['timestamp']).toString()}'),
              SizedBox(height: 20),
              Text('Question Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...List<Widget>.generate(
                (submission['answers'] as List).length,
                (index) {
                  final answer = (submission['answers'] as List)[index] as Map<String, dynamic>;
                  return ListTile(
                    dense: true,
                    leading: Icon(
                      answer['isCorrect'] ? Icons.check_circle : Icons.cancel,
                      color: answer['isCorrect'] ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      answer['questionTitle'],
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      'Selected: ${answer['selectedAnswerIndex']}, Correct: ${answer['correctAnswerIndex']}',
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    'Loading history...',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            )
          : submissions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 80, color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        'No quiz history yet!',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        'Complete a quiz to see your history here.',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Your Highest Score",
                            style: TextStyle(fontSize: 30, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '$highestScore',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Your Previous Scores (${submissions.length})',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    ...submissions.reversed.map((submission) {
                      final index = submissions.indexOf(submission);
                      return _buildSubmissionTile(submission, index);
                    }).toList(),
                    SizedBox(height: 30),
                    Center(
                      child: ButtonWidget(
                        text: 'Restart Quiz',
                        onPressed: widget.restartQuiz,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
    );
  }
}