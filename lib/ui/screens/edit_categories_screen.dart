import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';

class EditCategoriesScreen extends ConsumerWidget {
  const EditCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final baseCategories = [
      'Planet',
      'Star',
      'Galaxy',
      'Comet',
      'Black Hole',
      'Moon',
      'Satellite',
    ];
    final customCategories = ref
        .watch(customCategoriesProvider)
        .where((c) => !baseCategories.contains(c))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Categories")),
      body: customCategories.isEmpty
          ? const Center(
              child: Text(
                "You haven't created any custom categories yet.",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customCategories.length,
              itemBuilder: (context, index) {
                final category = customCategories[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white12),
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () =>
                              _showEditDialog(context, ref, category),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () =>
                              _showDeleteDialog(context, ref, category),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String oldCategory,
  ) {
    final controller = TextEditingController(text: oldCategory);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Category"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "New category name",
              hintText: "e.g. Nebula",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty && newName != oldCategory) {
                  ref
                      .read(customCategoriesProvider.notifier)
                      .updateCategoryName(oldCategory, newName);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Category '$oldCategory' was updated to '$newName'.",
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Category"),
          content: Text(
            "Are you sure you want to delete the '$category' category?\n\nWARNING: All space objects assigned to this category will be PERMANENTLY DELETED!",
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Category '$category' and all its items were deleted.",
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
