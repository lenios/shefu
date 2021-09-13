// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingredient_tuples.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientTupleAdapter extends TypeAdapter<IngredientTuple> {
  @override
  final int typeId = 2;

  @override
  IngredientTuple read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientTuple(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientTuple obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.unit)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.shape);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientTupleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
