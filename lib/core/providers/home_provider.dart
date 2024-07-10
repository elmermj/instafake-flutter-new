import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/dto/profile_response.dart';
import 'package:instafake_flutter/core/domain/dto/story_response.dart';
import 'package:instafake_flutter/core/domain/dto/user_response.dart';
import 'package:instafake_flutter/core/domain/repos/post_model_repository.dart';
import 'package:instafake_flutter/core/domain/repos/story_model_repository.dart';
import 'package:instafake_flutter/core/domain/repos/user_model_repository.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:path_provider/path_provider.dart';

class HomeProvider extends ChangeNotifier {
  final PostModelRepository _postRepo;
  final UserModelRepository _userRepo;
  final StoryModelRepository _storyRepo;
  final TextEditingController searchController = TextEditingController();
  final List<PostModel> _posts = [];
  final List<PostThumbnailModel> _explorePosts = [];
  final List<PostThumbnailModel> _profilePosts = [];
  final List<StoryResponse> _stories = [];
  final List<UserResponse> _searchedUsers = [];
  final ScrollController scrollController = ScrollController();
  final UserModel user = Get.find<UserDataService>().userDataBox.get(METADATA_KEY)!;
  final TextEditingController commentEditingController = TextEditingController();

  PostModel? currentPost;
  int _timelinePage = 0;
  final int _timelinePageSize = 20;
  int _explorePage = 0;
  final int _explorePageSize = 40;
  bool _isLoading = false;
  bool _hasMore = true;
  int _index = 0;
  List<bool> isExpanded = [];
  
  late String _mediaPath;
  late ProfileResponse myProfile = ProfileResponse(
    id: 1, 
    username: "default", 
    profImageUrl: null, 
    name: "default", 
    bio: null, 
    followers: [], 
    followings: [], 
    thumbnails: []
  ); 

  HomeProvider({
    required UserModelRepository userModelRepository,
    required PostModelRepository postModelRepository,
    required StoryModelRepository storyModelRepository
  }) : _postRepo = postModelRepository, _userRepo = userModelRepository, _storyRepo = storyModelRepository;

  List<PostModel> get posts => _posts;
  List<PostThumbnailModel> get explorePosts => _explorePosts;
  List<PostThumbnailModel> get profilePosts => _profilePosts;
  List<UserResponse> get searchedUsers => _searchedUsers;
  List<StoryResponse> get stories => _stories;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  int get index => _index;
  String get mediaPth => _mediaPath;

  commitLogout(){
    _userRepo.logout();
    Get.snackbar('Logged out', 'You have logged out from your account. We hope to see your return pretty soon.');
  }

  getMyProfile() async {
    _isLoading = true;
    // notifyListeners();
    try {
      final result = await _userRepo.getProfile(user.username);
      result.fold(
        (exception) {
          Get.snackbar('Error', "Profile retrieval error: $exception");
        },
        (profile) {
          myProfile = profile;
          notifyListeners();
          Log.green("TOTAL POSTS ::: ${profile.thumbnails?.length}");
        }
      );
      _isLoading = false;
    } on Exception catch (e) {
      Get.snackbar('Exception', e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTimeline(String username) async {
    _timelinePage=0;
    _posts.clear();
    notifyListeners();
    Log.yellow(_hasMore.toString());
    if (_isLoading) return;
    _isLoading = true;

    try {
      final result = await _postRepo.getTimeline(username, _timelinePage, _timelinePageSize);

      result.fold(
        (exception) {
          _isLoading = false;
          notifyListeners();
          Get.snackbar('Error', "Timeline retrieval error: $exception");
        },
        (posts) async {
          _timelinePage++;
          _hasMore = posts.length == _timelinePageSize;
          _posts.addAll(posts);
          for(var post in _posts){
            isExpanded.add(false);
          }
          await getStories();
          _isLoading = false;
          Log.green(posts.length.toString());
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<void> getAdminTimeline() async {
    _timelinePage=0;
    _posts.clear();
    notifyListeners();
    Log.yellow(_hasMore.toString());
    if (_isLoading) return;
    _isLoading = true;

    try {
      final result = await _postRepo.getAdminTimeline(_timelinePage, _timelinePageSize);

      result.fold(
        (exception) {
          _isLoading = false;
          notifyListeners();
          Get.snackbar('Error', "Admin Timeline retrieval error: $exception");
        },
        (posts) async {
          _timelinePage++;
          _hasMore = posts.length == _timelinePageSize;
          _posts.addAll(posts);
          for(var post in _posts){
            isExpanded.add(false);
          }
          await getStories();
          _isLoading = false;
          Log.green(posts.length.toString());
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<void> getStories() async {
    _stories.clear();

    try {
      final result = await _storyRepo.getStories();

      result.fold(
        (exception) {
          _isLoading = false;
          notifyListeners();
          Get.snackbar('Error', "Timeline retrieval error: $exception");
        },
        (stories) {
          _stories.addAll(stories);
          _isLoading = false;
          Log.green(stories.length.toString());
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<File?> getFile(String fileName) async {
    Log.yellow("GET FILE INITIATED");
    Directory directory = await getApplicationDocumentsDirectory();
    // String filePath = MEDIA_DIRECTORY(directory.path, fileName);
    String filePath = "${directory.path}/medias/$fileName";
    Log.pink("FILE Name ::: $fileName");
    Log.pink("FILE PATH ::: $filePath");
    File file = File(filePath);
    if (await file.exists()) {
      int fileSize = await file.length();
      Log.green("MEDIA IS SAVED IN DIRECTORY ::: ${file.path} | SIZE ::: $fileSize");
      // notifyListeners();
      return file;
    }else {
      Log.red("$file ::: NOT EXISTS");
      // notifyListeners();
      return null;
    }
    
  }

  searchUsers(String query) async {
    final result = await _userRepo.searchUser(query);
    result.fold(
      (exception){
        Get.snackbar('Error', "Search error: $exception");
      },
      (users){
        searchedUsers.clear();
        searchedUsers.addAll(users);
        notifyListeners();
      }
    );
  }

  Future<void> getExplore() async {
    _explorePage = 0;
    explorePosts.clear();
    if (_isLoading) return;

    _isLoading = true;
    // notifyListeners();

    try {
      Log.yellow("GET EXPLORE INITIATED");
      final result = await _postRepo.getExplore(_explorePage, _explorePageSize);

      result.fold(
        (exception){
          Get.snackbar('Error', "Timeline retrieval error : $exception");
        },
        (posts){
          _explorePage++;
          _isLoading = false;
          _hasMore = posts.length == _explorePageSize;
          _explorePosts.addAll(posts);
        }
      );
      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      Get.snackbar('Exception', e.toString());
    }
  }

  Future<void> getMoreExplore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    try {
      Log.yellow("GET EXPLORE INITIATED");
      final result = await _postRepo.getExplore(_explorePage, _explorePageSize);

      result.fold(
        (exception){
          Get.snackbar('Error', "Timeline retrieval error : $exception");
        },
        (posts){
          _explorePage++;
          _isLoading = false;
          _hasMore = posts.length == _explorePageSize;
          _explorePosts.addAll(posts);
        }
      );
      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      Get.snackbar('Exception', e.toString());
    }
  }
  // void _scrollListener() {
  //   if (scrollController.position.pixels == scrollController.position.minScrollExtent) {
  //     getMoreExplore();
  //   }
  // }
  void changeIndex(int input){
    _index = input;
    notifyListeners();
  }

  void setMedia(String input) {
    _mediaPath = input;
    notifyListeners();
  }
  
  addComment(String comment, String username, String postId) async {
    try {
      Log.yellow("GET EXPLORE INITIATED");
      final result = await _postRepo.addComment(comment, username, postId);

      result.fold(
        (exception){
          Get.snackbar("Error","$exception");
        },
        (success){
          commentEditingController.clear();
          currentPost = success;
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      Get.snackbar("Error","$e");
    }
  }

  Future<void> addLike(String postId, String userId, int index) async {
    try {
      final result = await _postRepo.addLike(postId, userId);

      result.fold(
        (exception){
          Get.snackbar("Error","$exception");
        },
        (success){
          _posts[index].isLiked = success;
          if(success){
            _posts[index].likeUserIds!.add(int.parse(userId));
          }
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      Get.snackbar("Error","$e");
    }
  }

  Future<void> removeLike(String postId, String userId, int index) async {
    try {
      final result = await _postRepo.removeLike(postId, userId);

      result.fold(
        (exception){
          Get.snackbar("Error","$exception");
        },
        (success){
          _posts[index].isLiked = success;
          if(success){
            _posts[index].likeUserIds!.remove(int.parse(userId));
          }
          notifyListeners();
        }
      );
    } on Exception catch (e) {
      Get.snackbar("Error","$e");
    }
  }

  void toggleCommentExpansion(int index) {
    _posts[index].isCommentExpanded = !_posts[index].isCommentExpanded!;
    notifyListeners();
  }

  void toggleCaptionExpansion(int index) {
    _posts[index].isCaptionExpanded = !_posts[index].isCaptionExpanded!;
    notifyListeners();
  }


}
