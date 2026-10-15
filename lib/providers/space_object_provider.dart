import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_app/models/space_object.dart';

class SpaceObjectsNotifier extends Notifier<List<SpaceObject>> {
  @override
  List<SpaceObject> build() {
    final box = Hive.box<SpaceObject>('space_objects');
    return box.values.toList();
  }

  void addObject(SpaceObject newObject) {
    final box = Hive.box<SpaceObject>('space_objects');
    box.put(newObject.id, newObject);
    state = [...state, newObject];
  }

  void deleteObject(String id) {
    final box = Hive.box<SpaceObject>('space_objects');
    box.delete(id);
    state = state.where((obj) => obj.id != id).toList();
  }

  void deleteObjectsByCategory(String category) {
    final box = Hive.box<SpaceObject>('space_objects');
    final objectsToDelete = state
        .where((obj) => obj.category == category)
        .toList();
    for (var obj in objectsToDelete) {
      box.delete(obj.id);
    }
    state = state.where((obj) => obj.category != category).toList();
  }

  void updateObject(SpaceObject updatedObject) {
    final box = Hive.box<SpaceObject>('space_objects');
    box.put(updatedObject.id, updatedObject);
    state = [
      for (final obj in state)
        if (obj.id == updatedObject.id) updatedObject else obj,
    ];
  }

  /// Updates category name for all objects that belonged to old category.
  /// Used when a custom category is renamed.
  void updateCategoryForObjects(String oldCategory, String newCategory) {
    final box = Hive.box<SpaceObject>('space_objects');
    bool updated = false;
    List<SpaceObject> newState = [...state];
    for (int i = 0; i < newState.length; i++) {
      if (newState[i].category == oldCategory) {
        final updatedObj = newState[i].copyWith(category: newCategory);
        box.put(updatedObj.id, updatedObj);
        newState[i] = updatedObj;
        updated = true;
      }
    }
    if (updated) {
      state = newState;
    }
  }

  /// Toggles favorite status of an object by its [id].
  /// Returns the new `isFavorite` status.
  bool toggleFavorite(String id) {
    final box = Hive.box<SpaceObject>('space_objects');
    final index = state.indexWhere((obj) => obj.id == id);
    if (index == -1) return false;

    final current = state[index];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    box.put(updated.id, updated);

    final newState = [...state];
    newState[index] = updated;
    state = newState;
    return updated.isFavorite;
  }
}

final spaceObjectsProvider =
    NotifierProvider<SpaceObjectsNotifier, List<SpaceObject>>(() {
      return SpaceObjectsNotifier();
    });

final searchQueryProvider = StateProvider<String>((ref) => '');

final favoritesFilterProvider = StateProvider<bool>((ref) => false);
