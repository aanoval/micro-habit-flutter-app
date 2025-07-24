import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/habit.dart';

// Screen to display habit statistics with charts
class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // Calculate longest streak
  int _calculateLongestStreak(List<DateTime> completionDates) {
    if (completionDates.isEmpty) return 0;
    completionDates.sort();
    int longestStreak = 1;
    int currentStreak = 1;
    for (int i = 1; i < completionDates.length; i++) {
      if (completionDates[i].difference(completionDates[i - 1]).inDays == 1) {
        currentStreak++;
        longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 1;
      }
    }
    return longestStreak;
  }

  // Prepare data for completion chart (last 7 days)
  List<BarChartGroupData> _getCompletionData(Habit habit) {
    final now = DateTime.now();
    final List<BarChartGroupData> data = [];
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final completions = habit.completionDates
          .where((d) => d.year == date.year && d.month == date.month && d.day == date.day)
          .length;
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: completions.toDouble(),
              color: Colors.amber,
              width: 10,
            ),
          ],
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Habit Statistics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Habit>('habits').listenable(),
          builder: (context, Box<Habit> box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Text(
                  'No habits to show statistics for!',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final habit = box.getAt(index)!;
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.amber,
                              child: Icon(
                                MdiIcons.fromString(habit.iconName) ?? MdiIcons.hail,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              habit.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current Streak: ${habit.streak} days',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Longest Streak: ${_calculateLongestStreak(habit.completionDates)} days',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          'Total Completions: ${habit.completionDates.length}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Completions (Last 7 Days)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 1,
                              barGroups: _getCompletionData(habit),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final daysAgo = 6 - value.toInt();
                                      final date = DateTime.now().subtract(Duration(days: daysAgo));
                                      return Text(
                                        '${date.day}/${date.month}',
                                        style: TextStyle(color: Colors.grey[700], fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Completion History:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          children: habit.completionDates
                              .map(
                                (date) => Chip(
                                  label: Text(
                                    '${date.day}/${date.month}/${date.year}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.amber,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}