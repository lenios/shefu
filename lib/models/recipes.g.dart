// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    )
      ..steps = (fields[3] as List).cast<int>()
      ..notes = fields[4] as String
      ..servings = fields[5] == null ? 4 : fields[5] as int
      ..tags = fields[6] == null ? [] : (fields[6] as List).cast<String>()
      ..category = fields[7] == null ? '' : fields[7] as String
      ..country_code = fields[8] == null ? '' : fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.source)
      ..writeByte(2)
      ..write(obj.image_path)
      ..writeByte(3)
      ..write(obj.steps)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.servings)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.country_code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
