import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> loginUser(String username, String password) async {
  final url = Uri.parse('http://127.0.0.1:5000/login');

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"username": username, "password": password}),
  );

  if (response.statusCode == 200) {
    return true; // Login success
  } else {
    return false; // Login failed
  }
}
