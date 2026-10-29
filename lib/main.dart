import 'package:flutter/material.dart';
import 'screens/a_list_screen.dart';

void main() {
  runApp(const PartifulApp());
}

class PartifulApp extends StatelessWidget {
  const PartifulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Partiful v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B5CF6),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),
      home: const AListScreen(),
    );
  }
}