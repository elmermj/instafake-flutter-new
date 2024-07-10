class UserResponse {
  String username;
  String? name;
  String? profImageUrl;
  int id;
  String? bio;

  UserResponse({
    required this.username,
    this.name,
    this.profImageUrl,
    required this.id,
    this.bio,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      username: json['username'],
      name: json['name'],
      profImageUrl: json['profImageUrl'],
      id: json['id'],
      bio: json['bio'],
    );
  }

  static Future<List<UserResponse>> fromJsonList(jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => UserResponse.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }
}