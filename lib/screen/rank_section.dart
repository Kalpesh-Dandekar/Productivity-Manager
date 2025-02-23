import 'dart:ui'; // For the BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RankSection extends StatefulWidget {
  const RankSection({Key? key}) : super(key: key);

  @override
  _RankSectionState createState() => _RankSectionState();
}

class _RankSectionState extends State<RankSection> {
  int points = 0;
  String rank = "Beginner";
  String rankDescription = "You are just starting!";
  String rankQuote = "The journey of a thousand miles begins with a single step.";

  void _updateRank() {
    if (points >= 1701) {
      rank = "Master";
      rankDescription = "You’ve reached the highest rank!";
      rankQuote = "The only way to do great work is to love what you do.";
    } else if (points >= 1001) {
      rank = "Achiever";
      rankDescription = "You’ve achieved greatness!";
      rankQuote = "Success is the sum of small efforts, repeated day in and day out.";
    } else if (points >= 501) {
      rank = "Challenger";
      rankDescription = "You’re a challenger now!";
      rankQuote = "The only limit to our realization of tomorrow is our doubts of today.";
    } else if (points >= 201) {
      rank = "Apprentice";
      rankDescription = "You’re learning fast!";
      rankQuote = "You are what you do, not what you say you'll do.";
    } else {
      rank = "Beginner";
      rankDescription = "You are just starting out!";
      rankQuote = "The journey of a thousand miles begins with a single step.";
    }
  }

  void _addPoints(int value) {
    setState(() {
      points += value;
      _updateRank();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rank System"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background effect using BackdropFilter for a smooth glassy look
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
              color: Colors.white.withOpacity(0.9), // Semi-transparent background for a glassy effect
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Rank Image
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      _getRankImage(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Rank and Points Text
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
                  // Rank Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      rankDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quote Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "\"$rankQuote\"",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Progress Bar
                  _buildProgressBar(),
                  const SizedBox(height: 20),
                  // Points Buttons
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
    double progress = (points % 500) / 500;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Progress",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white38,
            color: Colors.orange,
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPointsButtons() {
    return Column(
      children: [
        _customButton("Complete Minor Task (+20)", Colors.blue, () => _addPoints(20)),
        const SizedBox(height: 10),
        _customButton("Complete Major Task (+30)", Colors.green, () => _addPoints(30)),
        const SizedBox(height: 10),
        _customButton("Bonus Task (+40)", Colors.orange, () => _addPoints(40)),
      ],
    );
  }

  Widget _customButton(String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  String _getRankImage() {
    switch (rank) {
      case "Beginner":
        return 'assets/ranks/Beginner_rank.jpg';
      case "Apprentice":
        return 'assets/ranks/Apprentice_rank.jpg';
      case "Challenger":
        return 'assets/ranks/Challenger_rank.jpg';
      case "Achiever":
        return 'assets/ranks/Achiever_rank.jpg';
      case "Master":
        return 'assets/ranks/Master_rank.jpg';
      default:
        return 'assets/ranks/Beginner_rank.jpg';
    }
  }

  Color _getRankColor() {
    switch (rank) {
      case "Beginner":
        return Colors.grey;
      case "Apprentice":
        return Colors.blue;
      case "Challenger":
        return Colors.green;
      case "Achiever":
        return Colors.orange;
      case "Master":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
