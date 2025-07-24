import 'package:hive/hive.dart';
import '../models/habit.dart';

// Service to handle habit data operations
class HabitService {
  final Box<Habit> _habitBox = Hive.box<Habit>('habits');

  // Save or update a habit
  Future<void> saveHabit(Habit habit) async {
    final now = DateTime.now();
    // Reset completed count and update streak if it's a new day
    if (habit.lastReset.day != now.day) {
      if (habit.completedToday >= habit.frequency) {
        habit.streak++;
        habit.completionDates.add(DateTime(now.year, now.month, now.day));
      } else {
        habit.streak = 0; // Reset streak if not completed
      }
      habit.completedToday = 0;
      habit.lastReset = now;
    }
    await _habitBox.put(habit.id, habit);
  }

  // Delete a habit
  Future<void> deleteHabit(Habit habit) async {
    await _habitBox.delete(habit.id);
  }

  // Get all habits
  List<Habit> getHabits() {
    return _habitBox.values.toList();
  }
}