// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      token: fields[1] as String,
      username: fields[2] as String,
      realname: fields[3] as String,
      email: fields[4] as String,
      profImageUrl: fields[5] as String?,
      bio: fields[6] as String?,
      fileName: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      role: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.realname)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.profImageUrl)
      ..writeByte(6)
      ..write(obj.bio)
      ..writeByte(7)
      ..write(obj.fileName)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
