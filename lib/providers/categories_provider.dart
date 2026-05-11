import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_app/providers/space_object_provider.dart';

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);

class CustomCategoriesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final box = Hive.box<String>('custom_categories');
    if (box.isEmpty) {
      final defaultCategories = [
        'Planet',
        'Star',
        'Galaxy',
        'Comet',
        'Black Hole',
        'Moon',
        'Satellite',
      ];
      box.addAll(defaultCategories);
      return defaultCategories;
    }
    return box.values.toList();
  }

  void addCategory(String category) {
    if (!state.contains(category)) {
      final box = Hive.box<String>('custom_categories');
      box.add(category);
      state = [...state, category];
    }
  }

  /// Removes a custom category from the state and Hive database.
  /// Deletes all object linked to this category.
  void removeCategory(String category) {
    final box = Hive.box<String>('custom_categories');
    final key = box.keys.firstWhere(
      (k) => box.get(k) == category,
      orElse: () => null,
    );
    if (key != null) {
      box.delete(key);
      state = state.where((c) => c != category).toList();
      ref.read(spaceObjectsProvider.notifier).deleteObjectsByCategory(category);

      final selectedNotifier = ref.read(selectedCategoriesProvider.notifier);
      if (selectedNotifier.state.contains(category)) {
        selectedNotifier.state = selectedNotifier.state
            .where((c) => c != category)
            .toList();
      }
    }
  }

  /// Updates an EXISTING category's name.
  /// Synchronizes the change across all objects assigned to this category and active filters.
  void updateCategoryName(String oldName, String newName) {
    final box = Hive.box<String>('custom_categories');
    final key = box.keys.firstWhere(
      (k) => box.get(k) == oldName,
      orElse: () => null,
    );
    if (key != null) {
      box.put(key, newName);
      state = state.map((c) => c == oldName ? newName : c).toList();
      ref
          .read(spaceObjectsProvider.notifier)
          .updateCategoryForObjects(oldName, newName);

      final selectedNotifier = ref.read(selectedCategoriesProvider.notifier);
      if (selectedNotifier.state.contains(oldName)) {
        selectedNotifier.state = selectedNotifier.state
            .map((c) => c == oldName ? newName : c)
            .toList();
      }
    }
  }
}

final customCategoriesProvider =
    NotifierProvider<CustomCategoriesNotifier, List<String>>(() {
      return CustomCategoriesNotifier();
    });
