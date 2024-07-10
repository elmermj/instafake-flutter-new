import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:instafake_flutter/core/data/models/comment_model.dart';
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';
import 'package:instafake_flutter/core/data/models/suggestion_model.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/data/sources/local_post_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/local_user_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/remote_post_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/remote_story_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/remote_user_model_data_source.dart';
import 'package:instafake_flutter/core/domain/repos/post_model_repository.dart';
import 'package:instafake_flutter/core/domain/repos/story_model_repository.dart';
import 'package:instafake_flutter/core/domain/repos/user_model_repository.dart';
import 'package:instafake_flutter/services/account_service.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:http/http.dart' as http;
import 'package:instafake_flutter/utils/log.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils/constants.dart';

class DependencyInjection {
  static init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(PostModelAdapter());
    Hive.registerAdapter(PostThumbnailModelAdapter());
    Hive.registerAdapter(SuggestionModelAdapter());
    Hive.registerAdapter(CommentModelAdapter());
    final userBox = await Hive.openBox<UserModel>(METADATA_KEY);
    final postsBox = await Hive.openBox<PostModel>(POST_KEY);
    final postThumbnailsBox = await Hive.openBox<PostThumbnailModel>(POST_THUMBNAILS_KEY);
    final searchSuggestionsBox = await Hive.openBox<SuggestionModel>(SEARCH_SUGGESTIONS_KEY);
    final commentsBox = await Hive.openBox<SuggestionModel>(COMMENTS_KEY);

    http.Client client = http.Client();
    // String token = userBox.get(METADATA_KEY)?.token ?? '';
    //Data Source intances
    Get.put<RemoteUserModelDataSource>(RemoteUserModelDataSource(client));
    Get.put<RemoteStoryModelDataSource>(RemoteStoryModelDataSource(client));
    Get.put<RemotePostModelDataSource>(RemotePostModelDataSource(client, SERVER_URL));
    Get.put<LocalUserModelDataSource>(LocalUserModelDataSource(userBox, searchSuggestionsBox));
    Get.put<LocalPostModelDataSource>(LocalPostModelDataSource(postsBox, postThumbnailsBox, client));

    //storage intances
    Get.put(userBox);
    Get.put(postsBox);
    Get.put(postThumbnailsBox);
    Get.put(searchSuggestionsBox);
    Get.put(commentsBox);

    //service instances
    Get.put(UserDataService(userBox));
    DeviceStatusService accountService = Get.put(DeviceStatusService());

    //repository instances
    Get.put<UserModelRepository>(
      UserModelRepositoryImpl(
        localDataSource: Get.find(), 
        remoteDataSource: Get.find()
      )
    );

    Get.put<PostModelRepository>(
      PostModelRepositoryImpl(
        localDataSource: Get.find(), 
        remoteDataSource: Get.find()
      )
    );

    Get.put<StoryModelRepository>(
      StoryModelRepositoryImple(remoteDataSource: Get.find())
    );

    await requestPermissions(accountService);

  }

  static requestPermissions(DeviceStatusService accountService) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid && accountService.permissionsGranted.value==false){
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int apiLevel = androidInfo.version.sdkInt;
      Log.yellow("API LEVEL ::: $apiLevel");
      if(apiLevel >= 33){
        PermissionStatus storageStatus = await Permission.manageExternalStorage.request();
        PermissionStatus photosStatus = await Permission.photos.request();
        PermissionStatus cameraStatus = await Permission.camera.request();
        PermissionStatus videoStatus = await Permission.videos.request();
        PermissionStatus audioStatus = await Permission.audio.request();
        PermissionStatus mediaStatus = await Permission.mediaLibrary.request();
        PermissionStatus microphoneStatus = await Permission.microphone.request();

        if(
          storageStatus.isDenied &&
          photosStatus.isDenied &&
          cameraStatus.isDenied &&
          videoStatus.isDenied &&
          audioStatus.isDenied &&
          mediaStatus.isDenied &&
          microphoneStatus.isDenied
        ){
          accountService.permissionsGranted.value = false;
        }else {
          accountService.permissionsGranted.value = true;
        }
        Log.yellow("STORAGE STATUS ::: $storageStatus");
        Log.yellow("PHOTOS STATUS ::: $photosStatus"); 
        Log.yellow("CAMERA STATUS ::: $cameraStatus");
        Log.yellow("VIDEO STATUS ::: $videoStatus");
        Log.yellow("AUDIO STATUS ::: $audioStatus");
        Log.yellow("MEDIA STATUS ::: $mediaStatus");
        Log.yellow("MICROPHONE STATUS ::: $microphoneStatus");
        Log.yellow("Permission STATUS ::: ${accountService.permissionsGranted.value}");

      } else {
        PermissionStatus externalStorageStatus = await Permission.manageExternalStorage.request();
        PermissionStatus storageStatus = await Permission.storage.request();
        PermissionStatus microphoneStatus = await Permission.microphone.request();
        PermissionStatus cameraStatus = await Permission.camera.request();

        if(
          externalStorageStatus.isDenied && 
          storageStatus.isDenied &&
          microphoneStatus.isDenied &&
          cameraStatus.isDenied
        ){
          accountService.permissionsGranted.value = false;
        }else {
          accountService.permissionsGranted.value = true;
        }
      }
    }

    // Not tested on IOS
    // if(Platform.isIOS && accountService.permissionsGranted.value==false){
    //   IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //   if(iosInfo.systemVersion. >= '14.0'){
    //     PermissionStatus photosStatus = await Permission.photos.request();
    //     PermissionStatus cameraStatus = await Permission.camera.request();
    //     PermissionStatus videoStatus = await Permission.videos.request();
    //     PermissionStatus microphoneStatus = await Permission.microphone.request();
    //   } else {
    //     PermissionStatus storageStatus = await Permission.storage.request();
    //     PermissionStatus microphoneStatus = await Permission.microphone.request();
    //   }
    // }
  }

  static autoCleanCachedMedias<T>(){
    
  }

  static bool isJwtExpired(String token) {
    if(token.isEmpty) return true;

    bool isExpired = JwtDecoder.isExpired(token);
    Log.yellow(isExpired.toString());
    return isExpired;
  }

}