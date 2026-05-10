import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_app/models/space_object.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SpaceObjectAdapter());

    Box<SpaceObject> box = await Hive.openBox<SpaceObject>('space_objects');
    await Hive.openBox('apod_cache');

    if (box.isEmpty) {
      await box.addAll([
        SpaceObject(
          id: '1',
          name: 'Sun',
          category: 'Star',
          description: 'The star around which the earth orbits.',
          imagePath: 'assets/images/star.png',
          notes: '',
        ),
        SpaceObject(
          id: '2',
          name: 'Mars',
          category: 'Planet',
          description: 'The Red Planet, fourth from the Sun.',
          imagePath: 'assets/images/planet.png',
          notes: '',
        ),
        SpaceObject(
          id: '3',
          name: 'Andromeda',
          category: 'Galaxy',
          description: 'The nearest major galaxy to the Milky Way.',
          imagePath: 'assets/images/galaxy.png',
          notes: '',
        ),
      ]);
    }
  }
}
