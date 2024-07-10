
import 'package:hive/hive.dart';

part 'post_thumbnail_model.g.dart';

@HiveType(typeId: 2)
class PostThumbnailModel {
  @HiveField(0)
  int postId;
  @HiveField(1)
  String fileUrl;
  @HiveField(2)
  String fileName;
  @HiveField(3)
  String caption;
  @HiveField(4)
  DateTime createdAt;
  @HiveField(5)
  int userId;

  PostThumbnailModel({required this.postId, required this.fileUrl, required this.fileName, required this.caption, required this.createdAt, required this.userId});

  factory PostThumbnailModel.fromJson(Map<String, dynamic> json) {
    return PostThumbnailModel(
      postId: json['postId'] as int,
      fileUrl: json['fileUrl'] as String,
      fileName: json['fileName'] as String,
      caption: json['caption'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as int,
    );
  }
  
  static Future<List<PostThumbnailModel>> fromJsonList(jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => PostThumbnailModel.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }
}