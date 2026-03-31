import 'package:flutter/material.dart';
import 'pages/Teacher/teacher_page.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran App',
      home: TeacherDashboard(),
    );
  }
}
