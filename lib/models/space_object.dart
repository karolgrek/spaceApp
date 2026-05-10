import 'package:hive/hive.dart';
part 'space_object.g.dart';

@HiveType(typeId: 0)
class SpaceObject extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String imagePath;

  @HiveField(5)
  final String notes;

  SpaceObject({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.notes,
  });
}
