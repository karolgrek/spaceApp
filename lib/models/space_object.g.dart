// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'space_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpaceObjectAdapter extends TypeAdapter<SpaceObject> {
  @override
  final int typeId = 0;

  @override
  SpaceObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpaceObject(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      description: fields[3] as String,
      imagePath: fields[4] as String,
      notes: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SpaceObject obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpaceObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
