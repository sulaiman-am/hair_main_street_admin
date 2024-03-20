import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Sales This Month',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SalesChart(), // Add a chart widget for sales

            SizedBox(height: 20),

            Text(
              'New Users This Month',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            NewUsersChart(), // Add a chart widget for new users
          ],
        ),
      ),
    );
  }
}

class SalesChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with the actual logic to fetch sales data
    List<double> salesData = [100.0, 150.0, 200.0, 180.0];

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < salesData.length; i++)
                FlSpot(i.toDouble(), salesData[i]),
            ],
            isCurved: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
      ),
    );
  }
}

class NewUsersChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with the actual logic to fetch new users data
    List<int> newUsersData = [10, 15, 20, 18];

    return BarChart(
      BarChartData(
        barGroups: [
          for (int i = 0; i < newUsersData.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [BarChartRodData(toY: newUsersData[i].toDouble())],
            ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
      ),
    );
  }
}
