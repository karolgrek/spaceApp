import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';

class DeleteCategoryDialog extends ConsumerWidget {
  final String category;

  const DeleteCategoryDialog({super.key, required this.category});

  static Future<void> show(BuildContext context, String category) {
    return showDialog(
      context: context,
      builder: (context) => DeleteCategoryDialog(category: category),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text("Delete Category"),
      content: Text(
        "Are you sure you want to delete the '$category' category?\n\n"
        "WARNING: All space objects assigned to this category will be PERMANENTLY DELETED!",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          onPressed: () {
            ref
                .read(customCategoriesProvider.notifier)
                .removeCategory(category);
            Navigator.pop(context);
            AppSnackBar.showError(
              context,
              "Category '$category' and all its items were deleted.",
              icon: Icons.delete_outline,
            );
          },
          child: const Text(
            "Delete",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
