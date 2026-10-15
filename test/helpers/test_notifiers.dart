import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';

class TestCategoriesNotifier extends CustomCategoriesNotifier {
  final List<String> initial;
  TestCategoriesNotifier(this.initial);

  @override
  List<String> build() => initial;
}

class TestSpaceObjectsNotifier extends SpaceObjectsNotifier {
  final List<SpaceObject> initial;
  TestSpaceObjectsNotifier(this.initial);

  @override
  List<SpaceObject> build() => initial;

  @override
  bool toggleFavorite(String id) {
    final index = state.indexWhere((obj) => obj.id == id);
    if (index == -1) return false;
    final current = state[index];
    final updated = current.copyWith(isFavorite: !current.isFavorite);
    final newState = [...state];
    newState[index] = updated;
    state = newState;
    checkFavoritesReset();
    return updated.isFavorite;
  }
}
