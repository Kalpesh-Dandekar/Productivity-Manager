import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeSection extends StatefulWidget {
  final String username;
  const HomeSection({Key? key, required this.username}) : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  List<Map<String, dynamic>> tasks = [];
  int pomodoroMinutes = 25;
  int pomodoroSeconds = 0;
  bool isRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  /// ✅ Fetch tasks from Flask backend
  Future<void> _loadTasks() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/tasks?username=${widget.username}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedData = json.decode(response.body);
      setState(() {
        tasks = List<Map<String, dynamic>>.from(decodedData['tasks']);
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  /// ✅ Add a new task
  Future<void> _addTask(String task) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': widget.username, 'task': task, 'status': 'pending'}),
    );

    if (response.statusCode == 201) {
      _loadTasks();
    } else {
      throw Exception('Failed to add task');
    }
  }

  /// ✅ Update task completion status using task name
  Future<void> _markTaskCompleted(int index) async {
    Map<String, dynamic> taskData = tasks[index];

    final response = await http.put(
      Uri.parse('http://10.0.2.2:5000/tasks/mark-completed'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': widget.username,
        'task': taskData['task'],
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        taskData['status'] = taskData['status'] == 'completed' ? 'pending' : 'completed';
      });
    } else {
      throw Exception('Failed to update task');
    }
  }

  /// ✅ DELETE Task using task name
  Future<void> _deleteTask(int index) async {
    String taskName = tasks[index]['task'];

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:5000/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': widget.username, 'task': taskName}),
    );

    if (response.statusCode == 200) {
      setState(() {
        tasks.removeAt(index);
      });
    } else {
      throw Exception('Failed to delete task');
    }
  }

  /// ✅ Show task input dialog
  void _showTaskDialog() {
    String newTask = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            onChanged: (value) => newTask = value,
            decoration: const InputDecoration(labelText: 'Task'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                _addTask(newTask);
                Navigator.of(context).pop();
              },
              child: const Text('Add Task', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  /// ✅ Task Card Widget
  Widget _taskCard(int index) {
    Map<String, dynamic> taskData = tasks[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.orange,
      child: ListTile(
        title: Text(
          taskData['task'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: taskData['status'] == 'completed' ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                taskData['status'] == 'completed' ? Icons.check_circle : Icons.circle_outlined,
                color: Colors.white,
              ),
              onPressed: () => _markTaskCompleted(index),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _deleteTask(index),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Pomodoro Timer Functions
  void _startTimer() {
    if (!isRunning) {
      setState(() {
        isRunning = true;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (pomodoroMinutes == 0 && pomodoroSeconds == 0) {
            _stopTimer();
          } else if (pomodoroSeconds == 0) {
            pomodoroMinutes--;
            pomodoroSeconds = 59;
          } else {
            pomodoroSeconds--;
          }
        });
      });
    }
  }

  void _stopTimer() {
    setState(() {
      isRunning = false;
      pomodoroMinutes = 25;
      pomodoroSeconds = 0;
    });
    _timer?.cancel();
  }

  /// ✅ Circular Timer Widget
  Widget _buildCircularTimer() {
    double progress = ((pomodoroMinutes * 60 + pomodoroSeconds) / 1500);

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 10,
            backgroundColor: Colors.grey.shade300,
            color: Colors.orange,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$pomodoroMinutes:${pomodoroSeconds.toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Start", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Stop", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// ✅ Build UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome back, ${widget.username}!")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Tasks", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks added yet."))
                  : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) => _taskCard(index),
              ),
            ),
            const SizedBox(height: 20),
            Center(child: _buildCircularTimer()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
