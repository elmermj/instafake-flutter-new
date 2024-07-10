// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuggestionModelAdapter extends TypeAdapter<SuggestionModel> {
  @override
  final int typeId = 3;

  @override
  SuggestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SuggestionModel(
      suggestion: fields[0] as String,
      lastUpdated: fields[1] as DateTime,
      count: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SuggestionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.suggestion)
      ..writeByte(1)
      ..write(obj.lastUpdated)
      ..writeByte(2)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
