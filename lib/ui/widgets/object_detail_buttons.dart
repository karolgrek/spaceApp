import 'package:flutter/material.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/ui/screens/add_object_screen.dart';
import 'package:space_app/ui/widgets/dialogs/delete_object_dialog.dart';

class ObjectActionButtons extends StatelessWidget {
  final SpaceObject spaceobject;

  const ObjectActionButtons({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("EDIT"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddNewObject(objectToEdit: spaceobject),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "REMOVE",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => DeleteObjectDialog.show(context, spaceobject),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
