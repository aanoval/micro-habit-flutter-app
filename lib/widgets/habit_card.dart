import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/habit.dart';
import '../screens/add_habit_screen.dart';
import '../services/habit_service.dart';
import '../services/notification_service.dart';

// Modern habit card with progress and actions
class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final progress = habit.completedToday / habit.frequency;
    final isCompleted = habit.completedToday >= habit.frequency;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              child: Icon(
                MdiIcons.fromString(habit.iconName) ?? MdiIcons.hail,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Completed: ${habit.completedToday}/${habit.frequency} | Streak: ${habit.streak} days',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.amber,
                    minHeight: 6,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    MdiIcons.checkCircle,
                    color: isCompleted ? Colors.green : Colors.grey,
                    size: 36, // Larger button
                  ),
                  onPressed: () async {
                    if (habit.completedToday < habit.frequency) {
                      habit.completedToday++;
                      await HabitService().saveHabit(habit);
                    }
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(MdiIcons.dotsVertical, color: Colors.grey[700]),
                  onSelected: (value) async {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddHabitScreen(habit: habit)),
                      );
                    } else if (value == 'delete') {
                      await NotificationService().cancelHabitNotifications(habit);
                      await HabitService().deleteHabit(habit);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(MdiIcons.pencil, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          const Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(MdiIcons.delete, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}