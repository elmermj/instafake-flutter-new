// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 1;

  @override
  PostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostModel(
      id: fields[0] as int,
      fileUrl: fields[1] as String,
      fileName: fields[2] as String,
      caption: fields[3] as String,
      creatorUsername: fields[4] as String,
      createdAt: fields[6] as DateTime,
      creatorProfPicUrl: fields[5] as String?,
      comments: (fields[7] as List?)?.cast<CommentModel>(),
      likeUserIds: (fields[8] as List?)?.cast<int>(),
      isLiked: fields[9] as bool?,
      isCaptionExpanded: fields[11] as bool?,
      isCommentExpanded: fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileUrl)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.caption)
      ..writeByte(4)
      ..write(obj.creatorUsername)
      ..writeByte(5)
      ..write(obj.creatorProfPicUrl)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.comments)
      ..writeByte(8)
      ..write(obj.likeUserIds)
      ..writeByte(9)
      ..write(obj.isLiked)
      ..writeByte(10)
      ..write(obj.isCommentExpanded)
      ..writeByte(11)
      ..write(obj.isCaptionExpanded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
