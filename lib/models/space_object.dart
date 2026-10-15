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

  @HiveField(6)
  final bool isFavorite;

  SpaceObject({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.notes,
    this.isFavorite = false,
  });

  SpaceObject copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    String? imagePath,
    String? notes,
    bool? isFavorite,
  }) {
    return SpaceObject(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
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
          notes == other.notes &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      category.hashCode ^
      description.hashCode ^
      imagePath.hashCode ^
      notes.hashCode ^
      isFavorite.hashCode;
}
