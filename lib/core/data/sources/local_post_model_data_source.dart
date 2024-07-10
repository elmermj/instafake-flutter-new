import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';
import 'package:instafake_flutter/dependency_injection.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:path_provider/path_provider.dart';

class LocalPostModelDataSource {
  final http.Client _httpClient;
  final Box<PostModel> postMetadataBox;
  final Box<PostThumbnailModel> postThumbnailMetadataBox;

  LocalPostModelDataSource(this.postMetadataBox, this.postThumbnailMetadataBox, this._httpClient);

  Future<void> savePostMetadata(PostModel response, int postId) async {
    if(!postMetadataBox.containsKey("${POST_KEY}_$postId")) {
      await postMetadataBox.put("${POST_KEY}_$postId", response);
    }
    DependencyInjection.autoCleanCachedMedias();
  }

  Future<void> savePostThumbnailMetadata(PostThumbnailModel response, int postId) async {
    try {
      Log.yellow("SAVE POST THUMBNAIL METADATA INITIATED ::: $postId, ${response.fileName}, ${response.fileUrl}");
      if(!postThumbnailMetadataBox.containsKey("${POST_KEY}_$postId")) {
        Log.pink("MARK");
        Directory directory = await getApplicationDocumentsDirectory();
        String filename = response.fileUrl.split('/').last;
        Log.pink("FILE NAME ::: $filename");
        String filePath = MEDIA_DIRECTORY(directory.path, filename);
        Log.pink("GETTING FILE FROM ::: ${SERVER_URL+response.fileUrl}");
        final fileResponse = await _httpClient.get(Uri.parse(SERVER_URL+response.fileUrl));
      
        Log.yellow("CODE ::: ${fileResponse.statusCode} | SIZE ::: ${fileResponse.bodyBytes.length} | NAME ::: ${fileResponse.headers['content-disposition']}");
        File file = File(filePath);
        await file.create(recursive: true);
        await file.writeAsBytes(fileResponse.bodyBytes).then(
          (f) async {
            Log.green("FILE IS SAVED IN DIRECTORY ::: ${f.path}");
            await postThumbnailMetadataBox.put("${POST_KEY}_$postId", response);
          }
        );
        int fileSize = await file.length();
      
        Log.green("MEDIA IS SAVED IN DIRECTORY ::: ${file.path} | SIZE ::: $fileSize");
        
      }
      DependencyInjection.autoCleanCachedMedias();
    } on Exception catch (e) {
      Log.red(e.toString());
    }
  }

}