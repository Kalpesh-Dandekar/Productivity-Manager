import 'package:flutter/material.dart';
import 'homesection.dart';
import 'dashboard_section.dart';
import 'rank_section.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeSection(),
    DashboardScreen(),
    Text('Profile'),
    RankSection(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Taskify")),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Rank'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange, // Set the selected icon color
        unselectedItemColor: Colors.grey, // Set the unselected icon color
        onTap: _onItemTapped,
        showUnselectedLabels: true, // Show unselected labels as well
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Make selected label bold
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal), // Make unselected label normal
      ),
    );
  }
}
