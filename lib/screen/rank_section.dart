import 'dart:ui'; // For the BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RankSection extends StatefulWidget {
  final String username;
  const RankSection({Key? key, required this.username}) : super(key: key);

  @override
  _RankSectionState createState() => _RankSectionState();
}

class _RankSectionState extends State<RankSection> {
  int points = 0;
  String rank = "Beginner";
  String rankDescription = "You are just starting!";
  String rankQuote = "The journey of a thousand miles begins with a single step.";

  final String apiUrl = "http://10.0.2.2:5000"; // API endpoint

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl/rank/get_rank/${widget.username}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null) {
          setState(() {
            points = data['points'] ?? 0;
            rank = data['rank']['rank'] ?? "Beginner";
            rankDescription = data['rank']['description'] ?? "You are just starting!";
            rankQuote = data['rank']['quote'] ?? "The journey of a thousand miles begins with a single step.";
          });

          print("✅ User Data Loaded: $points points, Rank: $rank");
        } else {
          print("⚠️ No data received.");
        }
      } else {
        print('❌ Failed to load points: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading points: $e');
    }
  }

  Future<void> _savePoints(int value) async {
    try {
      print("🔄 Sending request to update points for ${widget.username}: $value");
      final response = await http.post(
        Uri.parse('$apiUrl/rank/update_points'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': widget.username, 'points': value}),
      );

      print("📩 Response Code: ${response.statusCode}");
      print("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        _loadPoints(); // Reload updated points and rank
      } else {
        print('❌ Failed to update points: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating points: $e');
    }
  }

  void _addPoints(int value) {
    _savePoints(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rank System - ${widget.username}"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.8), Colors.grey.withOpacity(0.8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 10,
              color: Colors.white.withOpacity(0.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      _getRankImage(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print("❌ Image not found: ${_getRankImage()}");
                        return Icon(Icons.image_not_supported, size: 100, color: Colors.grey);
                      },
                    ),
                  ),
                  Text(
                    "Rank: $rank",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getRankColor(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Points: $points",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      rankDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "\"$rankQuote\"",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProgressBar(),
                  const SizedBox(height: 20),
                  _buildPointsButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LinearProgressIndicator(
      value: points / 2000,
      backgroundColor: Colors.grey[300],
      color: _getRankColor(),
      minHeight: 10,
    );
  }

  Widget _buildPointsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => _addPoints(10),
          child: Text("+10 Points"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _addPoints(50),
          child: Text("+50 Points"),
        ),
      ],
    );
  }

  String _getRankImage() {
    String formattedRank = rank[0].toUpperCase() + rank.substring(1).toLowerCase();
    String imagePath = 'assets/ranks/${formattedRank}_rank.jpg';
    print("🖼️ Trying to load image: $imagePath");
    return imagePath;
  }


  Color _getRankColor() {
    Map<String, Color> rankColors = {
      "Beginner": Colors.grey,
      "Apprentice": Colors.blue,
      "Challenger": Colors.green,
      "Achiever": Colors.orange,
      "Master": Colors.red,
    };
    return rankColors[rank] ?? Colors.grey;
  }
}
