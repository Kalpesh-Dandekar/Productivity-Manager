import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text("Dashboard", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, User!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text("Your Progress Overview", style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tasks Pending: 5", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                  Text("Rank: Silver", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                  Text("Points: 1200", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                  Text("Upcoming Deadline: 2 days left", style: GoogleFonts.poppins(fontSize: 16, color: Colors.red.shade400)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
