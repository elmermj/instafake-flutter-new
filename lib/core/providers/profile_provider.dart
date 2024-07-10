import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/domain/dto/profile_response.dart';
import 'package:instafake_flutter/core/domain/repos/user_model_repository.dart';
import 'package:instafake_flutter/utils/log.dart';

class ProfileProvider extends ChangeNotifier{
  bool _isLoading = false;
  bool _isFollowLoading = false;
  bool _isFollowed = false;
  bool _isFollower = false;
  final UserModelRepository _userRepo;
  late ProfileResponse userProfile = ProfileResponse(
    id: 1, 
    username: "default", 
    profImageUrl: null, 
    name: "default", 
    bio: null, 
    followers: [], 
    followings: [], 
    thumbnails: []
  );

  ProfileProvider({required UserModelRepository userRepo}) : _userRepo = userRepo; 

  bool get isLoading => _isLoading;
  bool get isFollowLoading => _isFollowLoading;
  bool get isFollower => _isFollower;
  bool get isFollowing => _isFollowed;


  getUserProfile(String username) async {
    _isLoading = true;
    try {
      final result = await _userRepo.getProfile(username);
      result.fold(
        (exception) {
          Get.snackbar('Error', "Profile retrieval error: $exception");
        },
        (profile) {
          userProfile = profile;
          _isFollowed = userProfile.followings.contains(userProfile.id);
          _isFollower = userProfile.followers.contains(userProfile.id);
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

  follow(int id) async {
    _isFollowLoading = true;
    try {
      final result = await _userRepo.followUser(id, userProfile.id);
      result.fold(
        (exception){
          Get.snackbar('Error', "Unable to follow ${userProfile.username}");
          _isFollowLoading = false;
        }, 
        (success){
          _isFollowed = true;
          _isFollowLoading = false;
          notifyListeners();
          Get.snackbar('Followed!', "You have followed ${userProfile.username}");
        }
      );
      getUserProfile(userProfile.username);
    } on Exception catch (e) {
      Get.snackbar('Error', "Exception: $e");
    }
  }

  unfollow(int id)  async {
    _isFollowLoading = true;
    try {
      final result = await _userRepo.unfollowUser(id, userProfile.id);
      result.fold(
        (exception){
          Get.snackbar('Error', "Unable to umfollow ${userProfile.username}");
          _isFollowLoading = false;
        }, 
        (success){
          _isFollowed = false;
          _isFollowLoading = false;
          notifyListeners();
          Get.snackbar('Followed!', "You have unfollowed ${userProfile.username}");
        }
      );
      getUserProfile(userProfile.username);
    } on Exception catch (e) {
      Get.snackbar('Error', "Exception: $e");
      _isFollowLoading = false;
    }
  }

  removeFollower(int id) async {
    _isFollowLoading = true;
    try {
      final result = await _userRepo.removeUser(id, userProfile.id);
      result.fold(
        (exception){
          _isFollowLoading = false;
          Get.snackbar('Error', "Unable to remove ${userProfile.username}");
        }, 
        (success){
          _isFollowLoading = false;
          notifyListeners();
          Get.snackbar('Removed!', "You have removed ${userProfile.username}");
        }
      );
      getUserProfile(userProfile.username);
    } on Exception catch (e) {
      _isFollowLoading = false;
      Get.snackbar('Error', "Exception: $e");
    }
  }
}