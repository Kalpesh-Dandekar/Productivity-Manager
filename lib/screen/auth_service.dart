import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = "http://127.0.0.1:5000"; // Your Flask API URL

  Future<Map<String, dynamic>> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    return jsonDecode(response.body);
  }
}
