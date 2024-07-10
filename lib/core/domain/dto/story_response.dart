class StoryResponse {
  int storyId;
  String storyUrl;
  String storyAuthor;
  int authorId;
  DateTime createdAt;

  StoryResponse({
    required this.storyId,
    required this.storyUrl,
    required this.storyAuthor,
    required this.authorId,
    required this.createdAt,
  });

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      storyId: json['storyId'] as int,
      storyUrl: json['storyUrl'] as String,
      storyAuthor: json['storyAuthor'] as String,
      authorId: json['authorId'] as int,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Future<List<StoryResponse>> fromJsonList(dynamic jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => StoryResponse.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }
}
