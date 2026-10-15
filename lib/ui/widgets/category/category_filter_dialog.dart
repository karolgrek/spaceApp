import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';

class CategoryFilterDialog extends ConsumerWidget {
  const CategoryFilterDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const CategoryFilterDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesList = ref.watch(customCategoriesProvider);
    final selected = ref.watch(selectedCategoriesProvider);

    return AlertDialog(
      title: const Text('Filter by Category'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categoriesList.length,
            itemBuilder: (context, index) {
              final cat = categoriesList[index];
              final isChecked = selected.contains(cat);

              return CheckboxListTile(
                title: Text(cat),
                value: isChecked,
                onChanged: (bool? checked) {
                  final newList = List<String>.from(selected);
                  if (checked == true) {
                    newList.add(cat);
                  } else {
                    newList.remove(cat);
                  }
                  ref.read(selectedCategoriesProvider.notifier).state = newList;
                },
              );
            },
          ),
        ),
      ),
      actions: [
        if (selected.isNotEmpty)
          TextButton(
            onPressed: () {
              ref.read(selectedCategoriesProvider.notifier).state = [];
            },
            child: const Text('Clear All'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Done'),
        ),
      ],
    );
  }
}
