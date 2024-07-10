import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/dto/comment_request.dart';
import 'package:instafake_flutter/core/domain/dto/create_post_request.dart';
import 'package:instafake_flutter/core/domain/dto/like_request.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
class RemotePostModelDataSource {
  final http.Client _httpClient;
  final String _baseUrl;

  RemotePostModelDataSource(this._httpClient, this._baseUrl);

  Future<void> createPost(CreatePostRequest post, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('${_baseUrl}api/posts/create'));
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    request.fields['username'] = post.username;
    request.fields['caption'] = post.caption;
    request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    request.headers['Authorization'] = token;
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        Log.green('Create post success');
      } else {
        Log.red('Create post failed');
      }
    } catch (e) {
      Log.red('Create post failed');
    }
  }

  Future<List<PostThumbnailModel>> getExplore(int page, int pageSize) async {
    Log.yellow("GET EXPLORE PAGE DS ::: $page, PAGE SIZE ::: $pageSize");
    String requestURL = '${_baseUrl}api/posts/explore?page=$page&size=$pageSize';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow(token);
    Log.yellow(requestURL);
    final response = await _httpClient.post(Uri.parse(requestURL), headers: DEFAULT_HEADER(token));
    Log.yellow("GET EXPLORE RESPONSE BODY  ::: ${response.body} [${response.statusCode}]");
    if (response.statusCode == 200) {
      return await PostThumbnailModel.fromJsonList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get explore');
    }
  }

  Future<List<PostModel>> getTimeline(String username, int page, int pageSize) async {
    String requestURL = '${_baseUrl}api/posts/$username/timeline?page=$page&size=$pageSize';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow('Get timeline Auth Token : $token');
    final response = await _httpClient.post(Uri.parse(requestURL), headers: DEFAULT_HEADER(token));
    Log.yellow('RESPONSE 1 ::: ${response.body}');
    Log.yellow('Get timeline response (DS) [${response.statusCode}]: ${response.body}');
    
    if (response.statusCode == 200) {
      return PostModel.fromJsonList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get timeline');
    }
  }

  Future<List<PostModel>> getAdminTimeline(int page, int pageSize) async {
    String requestURL = '${_baseUrl}api/posts/admin/timeline?page=$page&size=$pageSize';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow('Get timeline Auth Token : $token');
    final response = await _httpClient.post(Uri.parse(requestURL), headers: DEFAULT_HEADER(token));
    Log.yellow('RESPONSE 1 ::: ${response.body}');
    Log.yellow('Get timeline response (DS) [${response.statusCode}]: ${response.body}');
    
    if (response.statusCode == 200) {
      return PostModel.fromJsonList(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get timeline');
    }
  }

  Future<PostModel> addComment(String comment, String username, String posId) async {
    String requestURL = '${_baseUrl}api/posts/$posId/comment';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow('Get timeline Auth Token : $token');
    Log.yellow('Get requestURL : $requestURL');
    final body = CommentRequest(comment: comment, username: username);
    Log.yellow('Get request body : ${body.toJson()}');
    final response = await _httpClient.post(
      Uri.parse(requestURL), 
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      body: jsonEncode(body.toJson())
    );
    Log.yellow('RESPONSE 1 ::: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add comment');
    }
  }

  //Gotta rush this one
  Future<bool> likePost(String postId, String userId) async {
    String requestURL = '${_baseUrl}api/posts/$postId/like?userId=$userId';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow('Get timeline Auth Token : $token');
    Log.yellow('Get requestURL : $requestURL');
    Log.yellow('Get postId : $postId, userId : $userId');
    final body = LikeRequest(postId: postId, userId: userId);
    final response = await _httpClient.post(
      Uri.parse(requestURL),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      // body: jsonEncode(body.toJson())
    );
    Log.yellow('REQUEST 1 ::: ${jsonEncode(body.toJson())}');
    Log.yellow('RESPONSE 1 ::: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unlikePost(String postId, String userId) async {
    String requestURL = '${_baseUrl}api/posts/$postId/unlike?userId=$userId';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow('Get timeline Auth Token : $token');
    Log.yellow('Get requestURL : $requestURL');
    Log.yellow('Get postId : $postId, userId : $userId');
    final body = LikeRequest(postId: postId, userId: userId);
    final response = await _httpClient.post(
      Uri.parse(requestURL),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
      // body: jsonEncode(body.toJson())
    );
    Log.yellow('REQUEST 1 ::: ${jsonEncode(body.toJson())}');
    Log.yellow('RESPONSE 1 ::: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}