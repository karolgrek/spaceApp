import 'package:flutter/material.dart';
import 'package:space_app/services/hive_service.dart';
import 'package:space_app/ui/screens/hp_notebook_screen.dart';
import 'package:space_app/ui/widgets/common/starry_background.dart';
import 'package:space_app/utils/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Notebook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return StarryBackground(child: child ?? const SizedBox());
      },
      home: const NotebookScreen(),
    );
  }
}
