import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:space_app/models/space_object.dart';
import 'package:space_app/providers/space_object_provider.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('space_objects_test_');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SpaceObjectAdapter());
    }
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

  group('SpaceObject Model Tests', () {
    test('copyWith updates specified fields only', () {
      final original = SpaceObject(
        id: '1',
        name: 'Earth',
        category: 'Planet',
        description: 'Blue planet',
        imagePath: 'path/to/earth.png',
        notes: 'Home',
      );

      final modified = original.copyWith(name: 'Earth (Updated)', notes: 'Our home');
      expect(modified.id, equals('1'));
      expect(modified.name, equals('Earth (Updated)'));
      expect(modified.category, equals('Planet'));
      expect(modified.notes, equals('Our home'));
    });

    test('operator == and hashCode match identical data', () {
      final obj1 = SpaceObject(
        id: '1',
        name: 'Jupiter',
        category: 'Planet',
        description: 'Gas giant',
        imagePath: '',
        notes: '',
      );
      final obj2 = SpaceObject(
        id: '1',
        name: 'Jupiter',
        category: 'Planet',
        description: 'Gas giant',
        imagePath: '',
        notes: '',
      );

      expect(obj1, equals(obj2));
      expect(obj1.hashCode, equals(obj2.hashCode));
    });
  });

  group('SpaceObjectsNotifier CRUD Tests', () {
    test('addObject adds to state and persists in Hive box', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final obj = SpaceObject(
        id: 'test_1',
        name: 'Titan',
        category: 'Moon',
        description: 'Saturnian moon',
        imagePath: '',
        notes: '',
      );

      notifier.addObject(obj);

      final state = container.read(spaceObjectsProvider);
      expect(state, contains(obj));

      final box = Hive.box<SpaceObject>('space_objects');
      expect(box.get('test_1'), isNotNull);
      expect(box.get('test_1')?.name, equals('Titan'));
    });

    test('updateObject updates existing object in state and Hive', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final obj = SpaceObject(
        id: 'test_2',
        name: 'Europa',
        category: 'Moon',
        description: 'Icy surface',
        imagePath: '',
        notes: '',
      );
      notifier.addObject(obj);

      final updatedObj = obj.copyWith(description: 'Subsurface ocean suspected');
      notifier.updateObject(updatedObj);

      final state = container.read(spaceObjectsProvider);
      expect(state.firstWhere((o) => o.id == 'test_2').description,
          equals('Subsurface ocean suspected'));

      final box = Hive.box<SpaceObject>('space_objects');
      expect(box.get('test_2')?.description,
          equals('Subsurface ocean suspected'));
    });

    test('deleteObject removes object from state and Hive', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final obj = SpaceObject(
        id: 'test_3',
        name: 'Io',
        category: 'Moon',
        description: 'Volcanic world',
        imagePath: '',
        notes: '',
      );
      notifier.addObject(obj);

      notifier.deleteObject('test_3');

      final state = container.read(spaceObjectsProvider);
      expect(state.any((o) => o.id == 'test_3'), isFalse);

      final box = Hive.box<SpaceObject>('space_objects');
      expect(box.get('test_3'), isNull);
    });

    test('deleteObjectsByCategory removes all matching objects from state and Hive', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final obj1 = SpaceObject(
        id: 'c_1',
        name: 'Halley',
        category: 'TestComet',
        description: '',
        imagePath: '',
        notes: '',
      );
      final obj2 = SpaceObject(
        id: 'c_2',
        name: 'Encke',
        category: 'TestComet',
        description: '',
        imagePath: '',
        notes: '',
      );
      final obj3 = SpaceObject(
        id: 'c_3',
        name: 'Ceres',
        category: 'Asteroid',
        description: '',
        imagePath: '',
        notes: '',
      );

      notifier.addObject(obj1);
      notifier.addObject(obj2);
      notifier.addObject(obj3);

      notifier.deleteObjectsByCategory('TestComet');

      final state = container.read(spaceObjectsProvider);
      expect(state.any((o) => o.category == 'TestComet'), isFalse);
      expect(state.any((o) => o.id == 'c_3'), isTrue);

      final box = Hive.box<SpaceObject>('space_objects');
      expect(box.get('c_1'), isNull);
      expect(box.get('c_2'), isNull);
      expect(box.get('c_3'), isNotNull);
    });

    test('toggleFavorite toggles isFavorite status in state and Hive box', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final obj = SpaceObject(
        id: 'fav_1',
        name: 'Venus',
        category: 'Planet',
        description: 'Morning star',
        imagePath: '',
        notes: '',
        isFavorite: false,
      );
      notifier.addObject(obj);

      // Toggle ON
      final resultOn = notifier.toggleFavorite('fav_1');
      expect(resultOn, isTrue);

      final stateOn = container.read(spaceObjectsProvider);
      expect(stateOn.firstWhere((o) => o.id == 'fav_1').isFavorite, isTrue);

      final box = Hive.box<SpaceObject>('space_objects');
      expect(box.get('fav_1')!.isFavorite, isTrue);

      // Toggle OFF
      final resultOff = notifier.toggleFavorite('fav_1');
      expect(resultOff, isFalse);

      final stateOff = container.read(spaceObjectsProvider);
      expect(stateOff.firstWhere((o) => o.id == 'fav_1').isFavorite, isFalse);
      expect(box.get('fav_1')!.isFavorite, isFalse);
    });

    test('toggleFavorite on non-existent ID returns false', () {
      final notifier = container.read(spaceObjectsProvider.notifier);
      final result = notifier.toggleFavorite('does_not_exist');
      expect(result, isFalse);
    });
  });
}
