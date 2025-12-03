import 'package:flutter/material.dart';
import '../../models/shared_prefs_storage.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  Future<Map<String, dynamic>> _loadDebugData() async {
    return await SharedPrefsStorage.exportAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DebugScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadDebugData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final data = snapshot.data!;
          
          return ListView(
            children: [
              ListTile(
                title: Text('Highest Score'),
                subtitle: Text('${data['highestScore']}'),
                leading: Icon(Icons.emoji_events, color: Colors.amber),
              ),
              Divider(),
              ListTile(
                title: Text('Questions JSON'),
                subtitle: Text(
                  data['questions']?.toString().substring(0, 100) ?? 'No questions',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  _showJsonDialog(context, 'Questions JSON', data['questions']);
                },
              ),
              Divider(),
              ListTile(
                title: Text('Submissions JSON'),
                subtitle: Text(
                  data['submissions']?.toString().substring(0, 100) ?? 'No submissions',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  _showJsonDialog(context, 'Submissions JSON', data['submissions']);
                },
              ),
              Divider(),
              ListTile(
                title: Text('All Keys in Storage'),
                subtitle: Text(
                  '${(data['keys'] as List).length} keys found',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () async {
                    await SharedPrefsStorage.clearAllData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('All data cleared!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => DebugScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('CLEAR ALL DATA', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showJsonDialog(BuildContext context, String title, String? json) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Container(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(
              json ?? 'No data',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
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
}