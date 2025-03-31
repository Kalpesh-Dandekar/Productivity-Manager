import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String username;

  const SettingsScreen({Key? key, required this.username}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false; // For notification toggle

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
        child: Column(
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildNotificationToggle(),
            const SizedBox(height: 10),
            _buildAboutButton(),
            const SizedBox(height: 10),
            _buildLogOutButton(),
            const SizedBox(height: 20),
            _buildQuote(),
          ],
        ),
      ),
    );
  }

  // ✅ User Profile Section
  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(4),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.orange),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.username,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // ✅ Notification Toggle
  Widget _buildNotificationToggle() {
    return _buildCard(
      icon: Icons.notifications,
      iconColor: Colors.orange,
      title: "Enable Notifications",
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() => _notificationsEnabled = value);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_notificationsEnabled ? "Notifications Enabled" : "Notifications Disabled")),
          );
        },
      ),
    );
  }

  // ✅ About App Button
  Widget _buildAboutButton() {
    return _buildCard(
      icon: Icons.info,
      iconColor: Colors.blue,
      title: "About App",
      onTap: _showAboutDialog,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("About Taskify"),
        content: const Text("Taskify is your ultimate productivity manager, helping you track tasks, goals, and more!"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK")),
        ],
      ),
    );
  }

  // ✅ Log Out Button
  Widget _buildLogOutButton() {
    return _buildCard(
      icon: Icons.exit_to_app,
      iconColor: Colors.red,
      title: "Log Out",
      titleColor: Colors.red,
      onTap: _showLogoutConfirmation,
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ✅ Motivational Quote
  Widget _buildQuote() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        '"The secret of getting ahead is getting started."',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black54),
      ),
    );
  }

  // ✅ Reusable Card Widget for ListTiles
  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color titleColor = Colors.black,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: TextStyle(fontSize: 18, color: titleColor)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
