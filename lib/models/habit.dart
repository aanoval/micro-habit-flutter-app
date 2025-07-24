import 'package:hive/hive.dart';

part 'habit.g.dart';

// Habit model for storing habit data
@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int frequency; // Times per day

  @HiveField(3)
  int completedToday;

  @HiveField(4)
  DateTime lastReset;

  @HiveField(5)
  int streak; // Consecutive days completed

  @HiveField(6)
  List<DateTime> completionDates; // Dates when habit was fully completed

  @HiveField(7)
  String iconName; // Material Design icon name

  Habit({
    required this.id,
    required this.name,
    required this.frequency,
    this.completedToday = 0,
    required this.lastReset,
    this.streak = 0,
    this.completionDates = const [],
    this.iconName = 'habit',
  });
}