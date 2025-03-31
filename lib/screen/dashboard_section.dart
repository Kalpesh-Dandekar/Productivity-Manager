import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GoalTrackerScreen extends StatefulWidget {
  final String username;

  GoalTrackerScreen({required this.username});

  @override
  _GoalTrackerScreenState createState() => _GoalTrackerScreenState();
}

class _GoalTrackerScreenState extends State<GoalTrackerScreen> {
  List<Map<String, dynamic>> goals = [];
  List<Map<String, dynamic>> achievements = [];

  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _achievementController = TextEditingController();

  final String apiUrl = "http://10.0.2.2:5000"; // Flask backend URL

  @override
  void initState() {
    super.initState();
    fetchGoalsAndAchievements();
  }

  Future<void> fetchGoalsAndAchievements() async {
    try {
      final goalsResponse = await http.get(Uri.parse('$apiUrl/goal?username=${widget.username}'));
      final achievementsResponse = await http.get(Uri.parse('$apiUrl/achievement?username=${widget.username}'));

      if (goalsResponse.statusCode == 200 && achievementsResponse.statusCode == 200) {
        setState(() {
          goals = List<Map<String, dynamic>>.from(json.decode(goalsResponse.body));
          achievements = List<Map<String, dynamic>>.from(json.decode(achievementsResponse.body));
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> addGoal() async {
    if (_goalController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('$apiUrl/goal'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": widget.username, "goal": _goalController.text}),
      );
      if (response.statusCode == 201) {
        fetchGoalsAndAchievements();
        _goalController.clear();
      }
    }
  }

  Future<void> markGoalCompleted(String goal) async {
    final response = await http.put(
      Uri.parse('$apiUrl/goal/complete'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": widget.username, "goal": goal}),
    );
    if (response.statusCode == 200) {
      fetchGoalsAndAchievements();
    }
  }

  Future<void> addAchievement() async {
    if (_achievementController.text.isNotEmpty) {
      final response = await http.post(
        Uri.parse('$apiUrl/achievement'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": widget.username, "text": _achievementController.text}),
      );
      if (response.statusCode == 201) {
        fetchGoalsAndAchievements();
        _achievementController.clear();
      }
    }
  }

  Future<void> deleteGoal(String goal) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/goal'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": widget.username, "goal": goal}),
    );
    if (response.statusCode == 200) {
      fetchGoalsAndAchievements();
    }
  }

  Future<void> deleteAchievement(String text) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/achievement'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": widget.username, "text": text}),
    );
    if (response.statusCode == 200) {
      fetchGoalsAndAchievements();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Goal Tracker"), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Goals"),
            SizedBox(height: 8),
            TextField(
              controller: _goalController,
              decoration: InputDecoration(
                hintText: "Enter a goal...",
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: addGoal,
              child: Text("Add Goal", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  var goal = goals[index];
                  return Card(
                    color: goal['completed'] ? Colors.green.shade200 : Colors.blue.shade200,
                    child: ListTile(
                      title: Text(goal['goal']),
                      trailing: Wrap(
                        spacing: 10,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.white),
                            onPressed: () => markGoalCompleted(goal['goal']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteGoal(goal['goal']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            _buildHeader("Achievements"),
            SizedBox(height: 8),
            TextField(
              controller: _achievementController,
              decoration: InputDecoration(
                hintText: "Enter achievement...",
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: addAchievement,
              child: Text("Add Achievement", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  var achievement = achievements[index];
                  return Card(
                    color: Colors.purple.shade200,
                    child: ListTile(
                      title: Text(achievement['text']),
                      subtitle: Text("Date: ${achievement['date']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteAchievement(achievement['text']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(8)),
      child: Center(
        child: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}
