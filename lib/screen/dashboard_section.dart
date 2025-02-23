import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Hello, Jimmy"),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildWeeklyComparisonCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: Colors.orangeAccent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔥 Rank Progress",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 5),
            LinearProgressIndicator(value: 0.6, backgroundColor: Colors.white70, color: Colors.white),
            const SizedBox(height: 15),
            _buildInfoRow("✅ Tasks Completed", "15"),
            _buildInfoRow("🎁 Bonus Earned (Week)", "150"),
            _buildInfoRow("🎁 Bonus Earned (Month)", "450"),
            const SizedBox(height: 10),
            const Text(
              "“Success is the sum of small efforts, repeated day in and day out.”",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildWeeklyComparisonCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("📊 Weekly Efficiency Comparison",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            SizedBox(height: 200, child: _buildBarChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barGroups: [
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: Colors.blue, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 8, color: Colors.orange, width: 16)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6, color: Colors.red, width: 16)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 7, color: Colors.green, width: 16)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 9, color: Colors.purple, width: 16)]),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) {
              List<String> days = ["Mon", "Tue", "Wed", "Thu", "Fri"];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(days[value.toInt() - 1], style: const TextStyle(fontSize: 14)),
              );
            }),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
      ),
    );
  }
}
