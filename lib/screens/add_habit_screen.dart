import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../services/notification_service.dart';

// Modern add/edit habit screen with icon selection
class AddHabitScreen extends StatefulWidget {
  final Habit? habit;

  const AddHabitScreen({super.key, this.habit});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _frequency;
  late String _iconName;

  // List of available icons
  final List<String> _icons = [
    'habit',
    'run',
    'book',
    'water',
    'meditation',
    'sleep',
    'food',
    'weight',
    'brush',
    'phone',
  ];

  @override
  void initState() {
    super.initState();
    _name = widget.habit?.name ?? '';
    _frequency = widget.habit?.frequency ?? 1;
    _iconName = widget.habit?.iconName ?? 'habit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.habit == null ? 'Add Habit' : 'Edit Habit',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeIn,
                    ),
                  ),
                  child: TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(
                      labelText: 'Habit Name',
                      prefixIcon: Icon(MdiIcons.text, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a habit name';
                      }
                      return null;
                    },
                    onSaved: (value) => _name = value!,
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeIn,
                    ),
                  ),
                  child: TextFormField(
                    initialValue: _frequency.toString(),
                    decoration: InputDecoration(
                      labelText: 'Frequency per Day',
                      prefixIcon: Icon(MdiIcons.counter, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                    onSaved: (value) => _frequency = int.parse(value!),
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeIn,
                    ),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _iconName,
                    decoration: InputDecoration(
                      labelText: 'Select Icon',
                      prefixIcon: Icon(MdiIcons.fromString(_iconName) ?? MdiIcons.hail, color: Colors.amber),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.deepPurple.shade300,
                    items: _icons.map((icon) {
                      return DropdownMenuItem(
                        value: icon,
                        child: Row(
                          children: [
                            Icon(MdiIcons.fromString(icon) ?? MdiIcons.hail, color: Colors.amber),
                            const SizedBox(width: 8),
                            Text(icon),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _iconName = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an icon';
                      }
                      return null;
                    },
                    onSaved: (value) => _iconName = value!,
                  ),
                ),
                const SizedBox(height: 20),
                ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(
                    CurvedAnimation(
                      parent: ModalRoute.of(context)!.animation!,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(MdiIcons.contentSave, color: Colors.deepPurple),
                    label: const Text('Save Habit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final habit = Habit(
                          id: widget.habit?.id ?? const Uuid().v4(),
                          name: _name,
                          frequency: _frequency,
                          completedToday: widget.habit?.completedToday ?? 0,
                          lastReset: widget.habit?.lastReset ?? DateTime.now(),
                          streak: widget.habit?.streak ?? 0,
                          completionDates: widget.habit?.completionDates ?? [],
                          iconName: _iconName,
                        );
                        await HabitService().saveHabit(habit);
                        await NotificationService().scheduleHabitNotification(habit);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}