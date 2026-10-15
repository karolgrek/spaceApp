import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/categories_provider.dart';
import 'package:space_app/providers/space_object_provider.dart';
import 'package:space_app/utils/app_constants.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('categories_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SpaceObjectAdapter());
    }
    await Hive.openBox<String>('custom_categories');
    await Hive.openBox<SpaceObject>('space_objects');
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CustomCategoriesNotifier Tests', () {
    test('initial state loads default base categories when empty', () {
      final categories = container.read(customCategoriesProvider);
      expect(categories, equals(AppConstants.baseCategories));
    });

    test('addCategory adds valid category and prevents duplicates case-insensitively', () {
      final notifier = container.read(customCategoriesProvider.notifier);

      final added = notifier.addCategory('Nebula');
      expect(added, isTrue);
      expect(container.read(customCategoriesProvider), contains('Nebula'));

      // Case-insensitive duplicate check
      final duplicateAdded = notifier.addCategory('nebula');
      expect(duplicateAdded, isFalse);

      // Whitespace check
      final emptyAdded = notifier.addCategory('   ');
      expect(emptyAdded, isFalse);

      // Reserved keyword check
      final reservedAdded = notifier.addCategory(AppConstants.createCustomCategoryOption);
      expect(reservedAdded, isFalse);
    });

    test('updateCategoryName updates category and cascades to space objects', () {
      final categoriesNotifier = container.read(customCategoriesProvider.notifier);
      final objectsNotifier = container.read(spaceObjectsProvider.notifier);

      categoriesNotifier.addCategory('Pulsar');
      final testObj = SpaceObject(
        id: 'obj_pulsar',
        name: 'Vela Pulsar',
        category: 'Pulsar',
        description: 'Test description',
        imagePath: '',
        notes: '',
      );
      objectsNotifier.addObject(testObj);

      final updated = categoriesNotifier.updateCategoryName('Pulsar', 'Magnetar');
      expect(updated, isTrue);
      expect(container.read(customCategoriesProvider), contains('Magnetar'));
      expect(container.read(customCategoriesProvider), isNot(contains('Pulsar')));

      final objects = container.read(spaceObjectsProvider);
      final updatedObj = objects.firstWhere((o) => o.id == 'obj_pulsar');
      expect(updatedObj.category, equals('Magnetar'));

      // Colliding update with existing category should fail
      final collisionUpdate = categoriesNotifier.updateCategoryName('Magnetar', 'Planet');
      expect(collisionUpdate, isFalse);
    });

    test('removeCategory deletes category and all objects associated with it', () {
      final categoriesNotifier = container.read(customCategoriesProvider.notifier);
      final objectsNotifier = container.read(spaceObjectsProvider.notifier);

      categoriesNotifier.addCategory('Supernova');
      objectsNotifier.addObject(
        SpaceObject(
          id: 'sn_1',
          name: 'SN 1987A',
          category: 'Supernova',
          description: '',
          imagePath: '',
          notes: '',
        ),
      );

      categoriesNotifier.removeCategory('Supernova');
      expect(container.read(customCategoriesProvider), isNot(contains('Supernova')));
      expect(container.read(spaceObjectsProvider).any((o) => o.category == 'Supernova'), isFalse);
    });
  });
}
