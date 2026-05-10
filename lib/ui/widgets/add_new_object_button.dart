import 'package:flutter/material.dart';
import 'package:space_app/ui/screens/add_object.dart';

class AddObjectButton extends StatelessWidget {
  const AddObjectButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
