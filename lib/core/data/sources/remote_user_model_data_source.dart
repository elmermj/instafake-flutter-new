import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/dto/follow_request.dart';
import 'package:instafake_flutter/core/domain/dto/profile_response.dart';
import 'package:instafake_flutter/core/domain/dto/user_response.dart';
import 'dart:convert';

import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';

class RemoteUserModelDataSource {
  final http.Client _client;

  RemoteUserModelDataSource(this._client);

  Future<Map<String, dynamic>> login(String username, String password) async {
    Log.yellow("LOGIN REMOTE DATA SOURCE INITIATED");
    final response = await _client.post(
      Uri.parse('${SERVER_URL}api/users/login'),
      body: jsonEncode({'username': username, 'password': password}),
      headers: DEFAULT_HEADER_NON_TOKEN,
    ).timeout(
      const Duration(
        seconds: 30
      )
    ).catchError((error){
      Log.red("LOGIN REMOTE DATA SOURCE ERROR ::: ${error.toString()}");
      throw Exception(error.toString());
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('[${response.statusCode}] Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
    String realname
  ) async {
    if (username.isEmpty || email.isEmpty || password.isEmpty || realname.isEmpty) {
      throw Exception('Please fill in all fields');
    } else {
      final response = await _client.post(
        Uri.parse('${SERVER_URL}api/users/register'),
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'realname': realname,
          'role' : 'USER'
        }),
        headers: DEFAULT_HEADER_NON_TOKEN
      ).timeout(
      const Duration(
        seconds: 30
      )
    ).catchError((error){
        Log.red("LOGIN REMOTE DATA SOURCE ERROR ::: ${error.toString()}");
        throw Exception(error.toString());
      });

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('[${response.statusCode}] Failed to login');
      }
    }
  }

  Future<List<UserResponse>> searchUser(
    String query
  ) async {
    Log.yellow("REQUESTING SEARCH TO SERVER ::: ${SERVER_URL}api/users/search/$query");
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    final response = await _client.post(
      Uri.parse('${SERVER_URL}api/users/search/$query'),
      headers: DEFAULT_HEADER(token)
    ).timeout(
      const Duration(
        seconds: 30
      )
    ).catchError((error){
      Log.red("SEARCH USERS REMOTE DATA SOURCE ERROR ::: ${error.toString()}");
      throw Exception(error.toString());
    });
    Log.yellow("${response.body} STATUS [${response.statusCode}]");
    return UserResponse.fromJsonList(jsonDecode(response.body));
  }

  Future<ProfileResponse> getMyProfile(
    String username
  ) async {
    Log.yellow("GETTING PROFILE ::: ${SERVER_URL}profile/$username");
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    final response = await _client.post(
      Uri.parse('${SERVER_URL}profile/$username'),
      headers: DEFAULT_HEADER(token)
    ).timeout(
      const Duration(
        seconds: 30
      )
    ).catchError((error){
      Log.red("GETTING PROFILE REMOTE DATA SOURCE ERROR ::: ${error.toString()}");
      throw Exception(error.toString());
    });
    Log.yellow("RESPONSE STATUS CODE ::: ${response.statusCode}");
    if (response.statusCode == 200) {
      Log.red("GETTING PROFILE REMOTE DATA SOURCE ::: ${response.body.toString()}");
      return ProfileResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('[${response.statusCode}] Failed to get profile');
    }
  }

  Future<void> followUser(FollowRequest request) async {
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    final url = Uri.parse('${SERVER_URL}profile/follow');
    final headers = DEFAULT_HEADER(token);
    final body = json.encode(request.toJson());

    Log.yellow('Request URL: $url');
    Log.yellow('Request Headers: $headers');
    Log.yellow('Request Body: $body');

    final response = await _client.post(
      url,
      headers: headers,
      body: body,
    );

    Log.yellow("RESPONSE STATUS CODE ::: ${response.statusCode}");
    if (response.statusCode != 202) {
      throw Exception('[${response.statusCode}] Failed to follow user');
    }
  }

  Future<void> unfollowUser(FollowRequest request) async {
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    final url = Uri.parse('${SERVER_URL}profile/unfollow');
    final headers = DEFAULT_HEADER(token);
    final body = json.encode(request.toJson());

    Log.yellow('Request URL: $url');
    Log.yellow('Request Headers: $headers');
    Log.yellow('Request Body: $body');

    final response = await _client.post(
      url,
      headers: headers,
      body: body,
    );

    Log.yellow("RESPONSE STATUS CODE ::: ${response.statusCode}");
    if (response.statusCode != 202) {
      throw Exception('[${response.statusCode}] Failed to follow user');
    }
  }

  Future<void> removeUser(FollowRequest request) async {
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    final response = await _client.post(
      Uri.parse('${SERVER_URL}profile/removeFollower'),
      headers: DEFAULT_HEADER(token),
      body: request.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception('[${response.statusCode}] Failed to remove follower');
    }
  }
  
}