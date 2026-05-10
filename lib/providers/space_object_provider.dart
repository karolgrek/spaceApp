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
}

final spaceObjectsProvider =
    NotifierProvider<SpaceObjectsNotifier, List<SpaceObject>>(() {
      return SpaceObjectsNotifier();
    });

final selectedCategoriesProvider = StateProvider<List<String>>((ref) => []);
