import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/dto/story_response.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
class RemoteStoryModelDataSource {
  final http.Client _client;

  RemoteStoryModelDataSource(this._client);

  Future<void> createStory(String username, File file) async {
    var request = http.MultipartRequest('POST', Uri.parse('${SERVER_URL}story/upload'));
    request.fields['username'] = username;
    request.files.add(http.MultipartFile('file', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    request.headers['Authorization'] = token;
    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        Log.green('Create post success');
      } else {
        Log.red('[${response.statusCode}] Create post failed');
      }
    } catch (e) {
      Log.red('Create post failed');
    }
  }

  Future<List<StoryResponse>>getStories() async {
    String requestURL = '${SERVER_URL}story/getStories';
    String token = Hive.box<UserModel>(METADATA_KEY).get(METADATA_KEY)!.token;
    Log.yellow(token);
    Log.yellow(requestURL);
    final response = await _client.post(Uri.parse(requestURL), headers: DEFAULT_HEADER(token));
    Log.yellow("GET EXPLORE RESPONSE BODY  ::: ${response.body} [${response.statusCode}]");
    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
      return await StoryResponse.fromJsonList(jsonDecode(response.body));
    } else {
      throw Exception('[${response.statusCode}] Failed to get explore');
    }
  }
}