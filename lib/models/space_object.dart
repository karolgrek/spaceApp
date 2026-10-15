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

  SpaceObject copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imagePath,
    String? notes,
  }) {
    return SpaceObject(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceObject &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          category == other.category &&
          description == other.description &&
          imagePath == other.imagePath &&
          notes == other.notes;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      category.hashCode ^
      description.hashCode ^
      imagePath.hashCode ^
      notes.hashCode;
}
