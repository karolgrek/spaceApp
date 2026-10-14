import 'package:flutter/material.dart';
import 'package:space_app/ui/screens/edit_categories_screen.dart';
import 'package:space_app/ui/widgets/common/starry_background.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: StarryBackground(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white24)),
              ),
              child: Text(
                "Settings",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text("Edit custom categories"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditCategoriesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
