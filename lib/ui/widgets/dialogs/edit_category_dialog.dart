import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/ui/widgets/feedback/app_snackbar.dart';

class EditCategoryDialog extends ConsumerStatefulWidget {
  final String oldCategory;

  const EditCategoryDialog({super.key, required this.oldCategory});

  static Future<void> show(BuildContext context, String oldCategory) {
    return showDialog(
      context: context,
      builder: (context) => EditCategoryDialog(oldCategory: oldCategory),
    );
  }

  @override
  ConsumerState<EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends ConsumerState<EditCategoryDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.oldCategory);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final newName = _controller.text.trim();
    if (newName.isNotEmpty && newName != widget.oldCategory) {
      ref
          .read(customCategoriesProvider.notifier)
          .updateCategoryName(widget.oldCategory, newName);
      AppSnackBar.showInfo(
        context,
        "Category '${widget.oldCategory}' was updated to '$newName'.",
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Category"),
      content: TextField(
        controller: _controller,
        maxLength: 35,
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
          onPressed: _onSave,
          child: const Text("Save", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
