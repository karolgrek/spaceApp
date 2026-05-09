import 'package:flutter/material.dart';
import 'package:space_app/utils/app_theme.dart';
import 'package:space_app/ui/screens/notebook_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Notebook',
      theme: AppTheme.darkTheme,
      home: const NotebookScreen(),
    );
  }
}
