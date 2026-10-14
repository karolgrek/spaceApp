import 'package:flutter/material.dart';
import 'package:space_app/ui/screens/add_object_screen.dart';

class AddObjectButton extends StatelessWidget {
  final bool mini;

  const AddObjectButton({super.key, this.mini = true});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: mini,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNewObject()),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
