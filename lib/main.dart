import 'package:flutter/material.dart';
import 'package:login_app/screen/homescreen.dart'; // Ensure homescreen.dart is imported

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const HomeScreen(), // Ensure it loads HomeScreen
    );
  }
}
