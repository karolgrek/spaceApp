import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/ui/widgets/category/favorites_filter_tile.dart';

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
    final allObjects = ref.watch(spaceObjectsProvider);
    final hasFavorites = allObjects.any((obj) => obj.isFavorite);
    final favoritesOnly = ref.watch(favoritesFilterProvider);

    return AlertDialog(
      title: const Text('Filter by Category'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (hasFavorites) const FavoritesFilterTile(),
              for (final cat in categoriesList)
                CheckboxListTile(
                  title: Text(cat),
                  value: selected.contains(cat),
                  onChanged: (bool? checked) {
                    final newList = List<String>.from(selected);
                    if (checked == true) {
                      newList.add(cat);
                    } else {
                      newList.remove(cat);
                    }
                    ref.read(selectedCategoriesProvider.notifier).state =
                        newList;
                  },
                ),
            ],
          ),
        ),
      ),
      actions: [
        if (selected.isNotEmpty || favoritesOnly)
          TextButton(
            onPressed: () {
              ref.read(selectedCategoriesProvider.notifier).state = [];
              ref.read(favoritesFilterProvider.notifier).state = false;
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
