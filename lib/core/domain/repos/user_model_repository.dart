import 'package:dartz/dartz.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/data/sources/local_user_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/remote_user_model_data_source.dart';
import 'package:instafake_flutter/core/domain/dto/follow_request.dart';
import 'package:instafake_flutter/core/domain/dto/profile_response.dart';
import 'package:instafake_flutter/core/domain/dto/user_response.dart';
import 'package:instafake_flutter/utils/log.dart';

abstract class UserModelRepository {
  Future<Either<Exception, UserModel>> login(String username, String password);
  Future<Either<Exception, UserModel>> getLocalData();
  Future<Either<Exception, UserModel>> register(
    String realname,
    String username,
    String email,
    String password,
  );
  Future<Either<Exception, List<UserResponse>>> searchUser(String query);
  Future<void> logout();
  Future<Either<Exception, ProfileResponse>> getProfile(String username);
  Future<Either<Exception, void>> followUser(int id, int otherId);
  Future<Either<Exception, void>> unfollowUser(int id, int otherId);
  Future<Either<Exception, void>> removeUser(int id, int otherId);
  
}

class UserModelRepositoryImpl extends UserModelRepository{
  final RemoteUserModelDataSource _remoteDataSource;
  final LocalUserModelDataSource _localDataSource;

  UserModelRepositoryImpl({required LocalUserModelDataSource localDataSource, required RemoteUserModelDataSource remoteDataSource}) : _localDataSource = localDataSource, _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Exception, UserModel>> login(String username, String password) async {
    Log.yellow("LOGIN REPO INITIATED");
    try {
      final response = await _remoteDataSource.login(username, password);
      final metadata = response['metadata'];
      Log.yellow("Metadata : ${metadata.toString()}");
      Log.yellow("Username : ${metadata['username']}");
      Log.yellow("Created At : ${metadata['createdAt'].toString()}");
      final authResponse = UserModel(
        id: metadata['id'], 
        token: response['token'], 
        username: metadata['username'], 
        realname: metadata['realname'], 
        email: metadata['email'],
        bio: metadata['bio'],
        // createdAt: DateFormat("yyyyMMddHHmmss").parse(metadata['created_at'])
        createdAt: DateTime.parse(metadata['createdAt']),
        role: metadata['role'],
      );
      await _localDataSource.saveUserMetadata(authResponse);
      return Right(authResponse);
    } on Exception catch (e) {
      return Left(Exception("Login failed : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Exception, UserModel>> register(
    String realname,
    String username,
    String email,
    String password
  ) async {
    try {
      final response = await _remoteDataSource.register(
        username,
        email,
        password,
        realname
      );
      final metadata = response['metadata'];
      Log.yellow("Metadata : ${metadata.toString()}");
      Log.yellow("Username : ${metadata['username']}");
      Log.yellow("Created At : ${metadata['createdAt'].toString()}");
      final authResponse = UserModel(
        id: metadata['id'], 
        token: response['token'], 
        username: metadata['username'], 
        realname: metadata['realname'], 
        email: metadata['email'],
        bio: metadata['bio'],
        // createdAt: DateFormat("yyyyMMddHHmmss").parse(metadata['created_at'])
        createdAt: DateTime.parse(metadata['createdAt']),
        role: metadata['role'],
      );
      await _localDataSource.saveUserMetadata(authResponse);
      return Right(authResponse);
    } on Exception catch (e) {
      return Left(Exception("Registration failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, UserModel>> getLocalData() async {
    try{
      UserModel? userData = _localDataSource.getUserMetadata();
      if(userData==null){
        return Left(Exception("User data not found"));
      }
      return Right(userData);
    } on Exception catch (e) {
      return Left(Exception("Registration failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<void> logout() async {
    _localDataSource.clearUserMetadata();
  }
  
  @override
  Future<Either<Exception, List<UserResponse>>> searchUser(String query) async {
    try {
      List<UserResponse> users = await _remoteDataSource.searchUser(query).then(
        (users) async {
          await _localDataSource.saveSuggestions(query);
          return users;
        }
      );
      return Right(users);
    } catch (e) {
      return Left(Exception("Search user failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, ProfileResponse>> getProfile(String username) async {
    try {
      final response = await _remoteDataSource.getMyProfile(username);
      return Right(response);
    } catch (e) {
      return Left(Exception("Get profile failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, void>> followUser(int id, int otherId) async {
    try {
      final FollowRequest request = FollowRequest(id: id, otherId: otherId);
      await _remoteDataSource.followUser(request);
      return const Right(null);
    }on Exception catch (e) {
      return Left(Exception("Exception : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, void>> removeUser(int id, int otherId) async {
    try {
      final FollowRequest request = FollowRequest(id: id, otherId: otherId);
      await _remoteDataSource.removeUser(request);
      return const Right(null);
    }on Exception catch (e) {
      return Left(Exception("Exception : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, void>> unfollowUser(int id, int otherId) async {
    try {
      final FollowRequest request = FollowRequest(id: id, otherId: otherId);
      await _remoteDataSource.unfollowUser(request);
      return const Right(null);
    }on Exception catch (e) {
      return Left(Exception("Exception : ${e.toString()}"));
    }
  }

  

}