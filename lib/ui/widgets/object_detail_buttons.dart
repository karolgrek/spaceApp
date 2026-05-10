import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';

class ObjectActionButtons extends ConsumerWidget {
  final SpaceObject spaceobject;

  const ObjectActionButtons({super.key, required this.spaceobject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // TODO :EDIT BUTTON
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("EDIT"),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16),
            //REMOVE BUTTON
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "REMOVE",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  _showDeleteConfirmation(context, ref, spaceobject);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    SpaceObject obj,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Delete Object"),
          content: Text("Are you sure you want to delete '${obj.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref.read(spaceObjectsProvider.notifier).deleteObject(obj.id);
                Navigator.pop(ctx);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${obj.name} deleted.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              child: const Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
