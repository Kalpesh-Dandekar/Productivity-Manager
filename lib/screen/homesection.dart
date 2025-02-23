import 'package:flutter/material.dart';
import 'dart:async';

class HomeSection extends StatefulWidget {
  const HomeSection({Key? key}) : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  int pomodoroMinutes = 25;
  int pomodoroSeconds = 0;
  bool isRunning = false;
  late Timer _timer;
  bool isDarkMode = false;

  // Task lists
  List<Map<String, dynamic>> tasks = [];

  // Streak progress and rank progress
  double streakProgress = 0.7; // example streak progress
  double rankProgress = 0.8; // example rank progress

  void _startPomodoro() {
    setState(() {
      isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (pomodoroSeconds > 0) {
        setState(() {
          pomodoroSeconds--;
        });
      } else if (pomodoroMinutes > 0) {
        setState(() {
          pomodoroMinutes--;
          pomodoroSeconds = 59;
        });
      } else {
        _timer.cancel();
        setState(() {
          isRunning = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pomodoro is over! Time for a break.')),
        );
      }
    });
  }

  void _pausePomodoro() {
    setState(() {
      isRunning = false;
    });
    _timer.cancel();
  }

  void _resetPomodoro() {
    setState(() {
      pomodoroMinutes = 25;
      pomodoroSeconds = 0;
      isRunning = false;
    });
    _timer.cancel();
  }

  // Function to add a new task
  void _addTask(String task, String priority) {
    setState(() {
      tasks.add({'task': task, 'priority': priority});
    });
  }

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome back, Jimmy!"),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_6),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Text & Motivational Quote
            const Text(
              "Welcome back, Jimmy!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "“The only way to do great work is to love what you do.”",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),

            // Rank Progress at the top right
            Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Rank: Master",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  LinearProgressIndicator(value: rankProgress, color: Colors.orange),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Task List with Priority Cards
            const Text(
              "Task List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _taskCard(tasks[index]);
                },
              ),
            ),

            // Quick Add Task Button
            ElevatedButton(
              onPressed: () {
                _showTaskDialog();
              },
              child: const Text("Add Task"),
            ),
            const SizedBox(height: 20),

            // Pomodoro Timer (Circle Design)
            const Text("Pomodoro Timer", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent,
                ),
                child: Center(
                  child: Text(
                    "$pomodoroMinutes:${pomodoroSeconds.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 30),
                  onPressed: _startPomodoro,
                ),
                IconButton(
                  icon: const Icon(Icons.pause, size: 30),
                  onPressed: _pausePomodoro,
                ),
                IconButton(
                  icon: const Icon(Icons.replay, size: 30),
                  onPressed: _resetPomodoro,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Streak Progress
            const Text("Streak: 5 Days", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: streakProgress,
              color: Colors.orange,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  // Task Card based on priority
  Widget _taskCard(Map<String, dynamic> taskData) {
    Color taskColor;
    switch (taskData['priority']) {
      case 'High':
        taskColor = Colors.red;
        break;
      case 'Medium':
        taskColor = Colors.yellow;
        break;
      default:
        taskColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: taskColor,
      child: ListTile(
        title: Text(
          taskData['task'],
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.check_circle_outline, color: Colors.white),
      ),
    );
  }

  // Dialog to Add a Task
  void _showTaskDialog() {
    String newTask = '';
    String selectedPriority = 'Low';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  newTask = value;
                },
                decoration: const InputDecoration(labelText: 'Task Description'),
              ),
              DropdownButton<String>(
                value: selectedPriority,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPriority = newValue!;
                  });
                },
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  _addTask(newTask, selectedPriority);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
  }
}
