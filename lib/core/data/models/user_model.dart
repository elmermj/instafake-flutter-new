import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject{
  @HiveField(0)
  int id;

  @HiveField(1)
  String token;

  @HiveField(2)
  String username;

  @HiveField(3)
  String realname;

  @HiveField(4)
  String email;

  @HiveField(5)
  String? profImageUrl;

  @HiveField(6)
  String? bio;

  @HiveField(7)
  String? fileName;

  @HiveField(8)
  DateTime createdAt;

  @HiveField(9)
  String role;

  UserModel({
    required this.id,
    required this.token,
    required this.username,
    required this.realname,
    required this.email,
    this.profImageUrl,
    this.bio,
    this.fileName,
    required this.createdAt,
    required this.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      token: json['token'],
      username: json['username'],
      realname: json['realname'],
      email: json['email'],
      profImageUrl: json['profImageUrl'],
      bio: json['bio'],
      fileName: json['fileName'],
      createdAt: DateTime.parse(json['createdAt'].replaceAll('T', ' ').substring(0, 19)),
      role: json['role']
    );
  }

  static Future<List<UserModel>> fromJsonList(jsonDecode) {
    if (jsonDecode is List) {
      return Future.value(jsonDecode.map((e) => UserModel.fromJson(e)).toList());
    } else {
      throw Exception('Failed to parse json list');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
      'username': username,
      'realname': realname,
      'email': email,
      'profImageUrl': profImageUrl,
      'bio': bio,
      'fileName': fileName,
      'createdAt': createdAt.toIso8601String(),
      'role': role
    };
  }
}
