import 'package:hive/hive.dart';
import 'comment_model.dart';

part 'post_model.g.dart';
@HiveType(typeId: 1)
class PostModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String fileUrl;
  @HiveField(2)
  String fileName;
  @HiveField(3)
  String caption;
  @HiveField(4)
  String creatorUsername;
  @HiveField(5)
  String? creatorProfPicUrl;
  @HiveField(6)
  DateTime createdAt;
  @HiveField(7)
  List<CommentModel>? comments;
  @HiveField(8)
  List<int>? likeUserIds;
  @HiveField(9)
  bool? isLiked;
  @HiveField(10)
  bool? isCommentExpanded;
  @HiveField(11)
  bool? isCaptionExpanded;

  PostModel({
    required this.id,
    required this.fileUrl,
    required this.fileName,
    required this.caption,
    required this.creatorUsername,
    required this.createdAt,
    this.creatorProfPicUrl,
    this.comments,
    this.likeUserIds,
    this.isLiked,
    this.isCaptionExpanded,
    this.isCommentExpanded,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      caption: json['caption'],
      creatorUsername: json['creatorUsername'],
      creatorProfPicUrl: json['creatorProfPicUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      comments: CommentModel.fromJsonList(json['comments']), 
      likeUserIds: json['userIdsLike']?.cast<int>() ?? [],
      isLiked: false,
      isCaptionExpanded: false,
      isCommentExpanded: false
    );
  }

  static Future<List<PostModel>> fromJsonList(dynamic jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => PostModel.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }
}