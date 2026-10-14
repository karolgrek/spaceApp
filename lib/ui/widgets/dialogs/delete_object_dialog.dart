import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';

class DeleteObjectDialog extends ConsumerWidget {
  final SpaceObject object;

  const DeleteObjectDialog({super.key, required this.object});

  static Future<void> show(BuildContext context, SpaceObject object) {
    return showDialog(
      context: context,
      builder: (context) => DeleteObjectDialog(object: object),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Delete Object"),
      content: Text("Are you sure you want to delete '${object.name}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            ref.read(spaceObjectsProvider.notifier).deleteObject(object.id);
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Close detail screen

            AppSnackBar.showError(
              context,
              '${object.name} deleted.',
              icon: Icons.delete_outline,
            );
          },
          child: const Text("OK", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
