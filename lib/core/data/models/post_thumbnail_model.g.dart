// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_thumbnail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostThumbnailModelAdapter extends TypeAdapter<PostThumbnailModel> {
  @override
  final int typeId = 2;

  @override
  PostThumbnailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostThumbnailModel(
      postId: fields[0] as int,
      fileUrl: fields[1] as String,
      fileName: fields[2] as String,
      caption: fields[3] as String,
      createdAt: fields[4] as DateTime,
      userId: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PostThumbnailModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.postId)
      ..writeByte(1)
      ..write(obj.fileUrl)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.caption)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostThumbnailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
