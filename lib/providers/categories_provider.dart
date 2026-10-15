import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/utils/app_constants.dart';

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);

class CustomCategoriesNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final box = Hive.box<String>('custom_categories');
    if (box.isEmpty) {
      box.addAll(AppConstants.baseCategories);
      return List<String>.from(AppConstants.baseCategories);
    }
    return box.values.toList();
  }

  bool containsCategory(String category) {
    final normalized = category.trim().toLowerCase();
    return state.any((c) => c.toLowerCase() == normalized);
  }

  bool addCategory(String category) {
    final trimmed = category.trim();
    if (trimmed.isEmpty ||
        trimmed.length > 35 ||
        trimmed == AppConstants.createCustomCategoryOption) {
      return false;
    }

    if (!containsCategory(trimmed)) {
      final box = Hive.box<String>('custom_categories');
      box.add(trimmed);
      state = [...state, trimmed];
      return true;
    }
    return false;
  }

  /// Removes a custom category from the state and Hive database.
  /// Deletes all objects linked to this category.
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
  bool updateCategoryName(String oldName, String newName) {
    final trimmedNew = newName.trim();
    if (trimmedNew.isEmpty ||
        trimmedNew.length > 35 ||
        trimmedNew == AppConstants.createCustomCategoryOption) {
      return false;
    }

    // Check if new name collides with another category (case-insensitive)
    final isDuplicate = state.any(
      (c) => c != oldName && c.toLowerCase() == trimmedNew.toLowerCase(),
    );
    if (isDuplicate) {
      return false;
    }

    final box = Hive.box<String>('custom_categories');
    final key = box.keys.firstWhere(
      (k) => box.get(k) == oldName,
      orElse: () => null,
    );
    if (key != null) {
      box.put(key, trimmedNew);
      state = state.map((c) => c == oldName ? trimmedNew : c).toList();
      ref
          .read(spaceObjectsProvider.notifier)
          .updateCategoryForObjects(oldName, trimmedNew);

      final selectedNotifier = ref.read(selectedCategoriesProvider.notifier);
      if (selectedNotifier.state.contains(oldName)) {
        selectedNotifier.state = selectedNotifier.state
            .map((c) => c == oldName ? trimmedNew : c)
            .toList();
      }
      return true;
    }
    return false;
  }
}

final customCategoriesProvider =
    NotifierProvider<CustomCategoriesNotifier, List<String>>(() {
      return CustomCategoriesNotifier();
    });
