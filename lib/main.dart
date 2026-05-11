import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:space_app/services/hive_service.dart';
import 'package:space_app/ui/widgets/starry_background.dart';
import 'package:space_app/utils/app_theme.dart';
import 'package:space_app/ui/screens/hp-notebook_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await HiveService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space Notebook',
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return StarryBackground(child: child ?? const SizedBox());
      },
      home: const NotebookScreen(),
    );
  }
}
