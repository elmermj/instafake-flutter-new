import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';

class ProfileResponse {
  final int id;
  final String username;
  final String? profImageUrl;
  final String? name;
  final String? bio;
  final List<int> followers;
  final List<int> followings;
  final List<PostThumbnailModel>? thumbnails;

  ProfileResponse({
    required this.id, 
    required this.username, 
    required this.profImageUrl, 
    required this.name, 
    required this.bio, 
    required this.followers, 
    required this.followings,
    required this.thumbnails
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      id: json['id'],
      username: json['username'],
      profImageUrl: json['profImageUrl'],
      name: json['name'],
      bio: json['bio'] ?? 'No bio',
      followers: List<int>.from(json['followers']),
      followings: List<int>.from(json['followings']),
      thumbnails: json['thumbnails'] == null 
          ? [] 
          : List<PostThumbnailModel>.from(json['thumbnails'].map((x) => PostThumbnailModel.fromJson(x)))
    );
  }

  static Future<List<ProfileResponse>> fromJsonList(dynamic jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => ProfileResponse.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }
}
