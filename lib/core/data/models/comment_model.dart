import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 4)
class CommentModel extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String comment;
  @HiveField(2)
  String author;
  @HiveField(3)
  DateTime timestamp;
  @HiveField(4)
  String? commenterProfPic;

  CommentModel({
    required this.id,
    required this.comment,
    required this.author,
    required this.timestamp,
    required this.commenterProfPic
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      comment: json['comment'],
      author: json['author'],
      timestamp: DateTime.parse(json['timestamp']),
      commenterProfPic: json['commenterProfPic']
    );
  }

  static List<CommentModel> fromJsonList(dynamic jsonList) {
    return jsonList.map<CommentModel>((json) => CommentModel.fromJson(json)).toList();
  }
}
