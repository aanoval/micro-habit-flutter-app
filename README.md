Micro Habit App 🌱
Build small habits, achieve big results!
Micro Habit is a modern Flutter app designed to help you build and track micro-habits effortlessly. With a vibrant UI, smooth animations, local storage using Hive, and smart notifications, it makes habit-building fun and engaging. Perfect for anyone looking to make small, impactful changes to their daily routine. 🚀

✨ Features

Add/Edit/Delete Habits: Create habits with custom names, daily frequencies, and personalized icons. 🖌️
Progress Tracking: Monitor daily completions with a sleek progress bar and streak counter. 📈
Statistics Dashboard: Visualize habit trends with bar charts and track current/longest streaks. 📊
Custom Icons: Choose from a variety of Material Design icons to personalize your habits. 🎨
Local Notifications: Receive reminders daily at 8 AM for your habits. 🔔
Persistent Storage: Uses Hive for fast, lightweight local data storage. 💾
Modern UI/UX: Enjoy a gradient-themed interface with neumorphic cards and smooth animations. 🌟
Clean & Modular Code: Built with clean code principles for easy maintenance and scalability. 🛠️


🚀 Getting Started
Prerequisites

Flutter: Version 2.18.0 or higher
Dart: Included with Flutter
Android Emulator/Device: For testing notifications
Code Editor: VS Code or Android Studio recommended

Installation

Clone the Repository:
git clone https://github.com/aanoval/micro-habit-flutter-app
cd micro-habit


Install Dependencies:
flutter pub get


Generate Hive Adapters:
flutter pub run build_runner build


Run the App:
flutter run




📂 Project Structure



Directory/File
Description



lib/models/habit.dart
Habit model with Hive annotations


lib/screens/home_screen.dart
Main screen displaying habit list


lib/screens/add_habit_screen.dart
Screen for adding/editing habits with icon selection


lib/screens/statistics_screen.dart
Dashboard for habit statistics with charts


lib/services/habit_service.dart
Logic for habit CRUD operations


lib/services/notification_service.dart
Notification scheduling logic


lib/widgets/habit_card.dart
Widget for displaying a habit with progress and actions


lib/main.dart
App entry point


pubspec.yaml
Dependencies and configuration


README.md
Project documentation



📦 Dependencies

hive & hive_flutter: Local storage for habits
flutter_local_notifications: Daily reminders at 8 AM
uuid: Unique habit IDs
timezone: Notification scheduling
animations: Smooth UI transitions
material_design_icons_flutter: Customizable habit icons
fl_chart: Bar charts for statistics
hive_generator & build_runner: Hive adapter generation


📸 Screenshots



Home Screen
Add Habit Screen
Statistics Screen









🛠️ Usage
Add a Habit

Click the + floating action button on the home screen.
Enter the habit name (e.g., "Drink Water"), daily frequency (e.g., 3 times/day), and select an icon (e.g., water drop).
Save to add the habit and schedule a daily 8 AM notification.

Track Progress

Tap the large checkmark (gray when incomplete, green when complete) to mark a habit as done.
View progress via the progress bar and streak counter (e.g., "2/3 completed | Streak: 5 days").

Edit/Delete

Use the three-dot menu on a habit card to edit or delete.
Edit allows updating the name, frequency, or icon; delete cancels notifications.

View Statistics

Tap the chart icon in the app bar to access the statistics dashboard.
See current/longest streaks, total completions, and a bar chart of completions over the last 7 days.


🤝 Contributing
We welcome contributions to enhance Micro Habit! Here's how to get started:

Fork the Repository:Click the "Fork" button on GitHub.

Create a Feature Branch:
git checkout -b feature/your-feature-name


Commit Changes:
git commit -m "Add your feature description"


Push to GitHub:
git push origin feature/your-feature-name


Open a Pull Request:Describe your changes and submit the PR.


Contribution Ideas

Add Lottie animations for habit completion celebrations. 🎉
Implement a dark mode toggle or custom themes. 🌙
Add export/import functionality for habits. 📤
Integrate streaks with a calendar view. 📅


📜 License
This project is licensed under the MIT License. See the LICENSE file for details.

🌟 Why Micro Habit?
Micro Habit is designed to be simple, effective, and visually engaging. By focusing on small, achievable tasks, it helps you build lasting habits without feeling overwhelmed. The modern UI, complete with animations, custom icons, and insightful statistics, makes habit tracking a delightful experience. The clean codebase is perfect for developers to extend with new features. 💪

📬 Contact
Have questions or suggestions? Reach out via:

GitHub Issues: Create an issue
Email: aanovalu@gmail.com

Let's build better habits together! 🌈