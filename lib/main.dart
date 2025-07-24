import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/habit.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';

// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(HabitAdapter());
    await Hive.openBox<Habit>('habits');
  } catch (e) {
    debugPrint('Error initializing Hive: $e');
  }

  // Initialize notifications
  await NotificationService().init();

  runApp(const MicroHabitApp());
}

// Root widget of the application
class MicroHabitApp extends StatelessWidget {
  const MicroHabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Micro Habit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}