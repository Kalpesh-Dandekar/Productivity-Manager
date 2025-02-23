import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false; // for Theme Toggle
  bool _notificationsEnabled = true; // for Notification Settings

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Icon with Name at the top
            _buildProfileSection(),
            const SizedBox(height: 20),

            // Profile Information Section
            _buildSettingCard(Icons.account_box, "Profile Information", () {
              // Handle Profile Information Navigation
            }),
            const SizedBox(height: 20),

            // Theme Toggle (Dark/Light)
            _buildThemeToggle(),
            const SizedBox(height: 20),

            // Notification Settings
            _buildNotificationToggle(),
            const SizedBox(height: 20),

            // Account Management Section
            _buildSettingCard(Icons.lock, "Account Management", () {
              // Handle Account Management Navigation
            }),
            const SizedBox(height: 20),

            // Log Out Option
            _buildLogOutButton(),
          ],
        ),
      ),
    );
  }

  // Profile Section with Large Icon and Name
  Widget _buildProfileSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60, // Large Profile Icon
          backgroundImage: NetworkImage('https://www.example.com/profile-image.jpg'),
        ),
        const SizedBox(height: 10),
        const Text(
          'User Name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        const Text(
          'user@example.com', // Profile Email or User Info
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  // General Setting Card
  Widget _buildSettingCard(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Theme Toggle (Dark/Light)
  Widget _buildThemeToggle() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.brightness_6, color: Colors.orange),
        title: const Text("Dark Mode", style: TextStyle(fontSize: 18)),
        trailing: Switch(
          value: _isDarkMode,
          onChanged: (value) {
            setState(() {
              _isDarkMode = value;
            });
          },
        ),
      ),
    );
  }

  // Notification Settings Toggle
  Widget _buildNotificationToggle() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.notifications, color: Colors.orange),
        title: const Text("Notifications", style: TextStyle(fontSize: 18)),
        trailing: Switch(
          value: _notificationsEnabled,
          onChanged: (value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
      ),
    );
  }

  // Log Out Button
  Widget _buildLogOutButton() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.exit_to_app, color: Colors.orange),
        title: const Text("Log Out", style: TextStyle(fontSize: 18, color: Colors.red)),
        onTap: () {
          // Implement Log Out Logic
        },
      ),
    );
  }
}
