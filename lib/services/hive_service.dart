import 'package:hive_flutter/hive_flutter.dart';
import 'package:space_app/models/space_object.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SpaceObjectAdapter());

    Box<SpaceObject> box = await Hive.openBox<SpaceObject>('space_objects');
    await Hive.openBox('apod_cache');
    await Hive.openBox<String>('custom_categories');

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
          name: 'Arrakis (Dune)',
          category: 'Planet',
          description:
              'Also known as Dune, this desert world is the sole source of the spice melange and known for its massive sandworms.',
          imagePath: 'assets/images/planet.png',
          notes: "Muad'Dib!",
        ),
        SpaceObject(
          id: '4',
          name: 'Andromeda',
          category: 'Galaxy',
          description: 'The nearest major galaxy to the Milky Way.',
          imagePath: 'assets/images/galaxy.png',
          notes: '',
        ),
        SpaceObject(
          id: '5',
          name: 'Halley\'s Comet',
          category: 'Comet',
          description:
              'A short-period comet visible from Earth every 75–76 years.',
          imagePath: 'assets/images/comet.png',
          notes: 'Next perihelion is in 2061.',
        ),
        SpaceObject(
          id: '6',
          name: 'Sagittarius A*',
          category: 'Black Hole',
          description:
              'The supermassive black hole at the Galactic Center of the Milky Way.',
          imagePath: 'assets/images/black_hole.png',
          notes: '',
        ),
        SpaceObject(
          id: '7',
          name: 'Luna',
          category: 'Moon',
          description: "Earth's only natural satellite.",
          imagePath: 'assets/images/moon.png',
          notes: '',
        ),
        SpaceObject(
          id: '8',
          name: 'Hubble Space Telescope',
          category: 'Satellite',
          description:
              'A space telescope launched into low Earth orbit in 1990.',
          imagePath: 'assets/images/satellite.png',
          notes: '',
        ),
      ]);
    }
  }
}
