import 'package:flutter/material.dart';
import 'package:login_app/screen/homesection.dart';
import 'package:login_app/screen/dashboard_section.dart';
import 'package:login_app/screen/rank_section.dart';
import 'package:login_app/screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = [
      HomeSection(username: widget.username),
      GoalTrackerScreen(username: widget.username),
      RankSection(username: widget.username),
      SettingsScreen(username: widget.username),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Taskify - Welcome, ${widget.username}")),
      body: SafeArea(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Goal Tracker'),          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Rank'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
