import 'package:flutter/material.dart';
import 'package:space_app/ui/widgets/dialogs/delete_category_dialog.dart';
import 'package:space_app/ui/widgets/dialogs/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {
  final String category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => EditCategoryDialog.show(context, category),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () => DeleteCategoryDialog.show(context, category),
            ),
          ],
        ),
      ),
    );
  }
}
