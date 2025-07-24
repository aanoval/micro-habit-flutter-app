import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animations/animations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/habit.dart';
import '../screens/add_habit_screen.dart';
import '../screens/statistics_screen.dart';
import '../widgets/habit_card.dart';

// Modern home screen with animated habit list
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Micro Habits',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(MdiIcons.chartLine, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatisticsScreen()),
            ),
          ),
        ],
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
                  'No habits yet. Add one!',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: box.length,
              itemBuilder: (context, index) {
                final habit = box.getAt(index)!;
                return HabitCard(habit: habit);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AddHabitScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeScaleTransition(animation: animation, child: child);
            },
          ),
        ),
        child: Icon(MdiIcons.plus, color: Colors.deepPurple),
      ),
    );
  }
}