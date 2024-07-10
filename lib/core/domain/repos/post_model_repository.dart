import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/post_thumbnail_model.dart';
import 'package:instafake_flutter/core/data/sources/local_post_model_data_source.dart';
import 'package:instafake_flutter/core/data/sources/remote_post_model_data_source.dart';
import 'package:instafake_flutter/core/domain/dto/create_post_request.dart';
import 'package:instafake_flutter/utils/log.dart';

abstract class PostModelRepository {
  Future<Either<Exception, void>> createPost(CreatePostRequest creatPostRequest, File file);
  Future<Either<Exception, PostModel>> getPost(int postId);
  Future<Either<Exception, List<PostThumbnailModel>>> getExplore(int page, int pageSize);
  Future<Either<Exception, List<PostModel>>> getTimeline(String username, int page, int pageSize);
  Future<Either<Exception, List<PostModel>>> getAdminTimeline(int page, int pageSize);
  Future<void> deletePost(int postId);

  Future<Either<Exception, PostModel>> addComment(String comment, String username, String posId);
  Future<Either<Exception, bool>> addLike(String postId, String userId);
  Future<Either<Exception, bool>> removeLike(String postId, String userId);
}

class PostModelRepositoryImpl implements PostModelRepository {
  final RemotePostModelDataSource _remoteDataSource;
  final LocalPostModelDataSource _localDataSource;

  PostModelRepositoryImpl({required RemotePostModelDataSource remoteDataSource, required LocalPostModelDataSource localDataSource}) : _remoteDataSource = remoteDataSource, _localDataSource = localDataSource;
  
  @override
  Future<Either<Exception, void>> createPost(CreatePostRequest creatPostRequest, File file) async {
    try {
      await _remoteDataSource.createPost(creatPostRequest, file);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Exception("Create post failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<void> deletePost(int postId) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Exception, List<PostThumbnailModel>>> getExplore(int page, int pageSize) async {
    try {
      Log.yellow("GET EXPLORE PAGE ::: $page, PAGE SIZE ::: $pageSize");
      List<PostThumbnailModel> explorePostThumbnails = await _remoteDataSource.getExplore(page, pageSize).then((explorePosts) {
        if (explorePosts.isNotEmpty) {
          for (var explorePost in explorePosts) {
            _localDataSource.savePostThumbnailMetadata(explorePost, explorePost.postId);
          }
          return explorePosts;        
        }
        return [];
      });
      if (explorePostThumbnails.isNotEmpty) {
        return Right(explorePostThumbnails);
      } else {
        return Left(Exception("Timeline not available"));
      }
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, PostModel>> getPost(int postId) {
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Exception, List<PostModel>>> getTimeline(String username, int page, int pageSize) async {
    try {
      List<PostModel> timeline = await _remoteDataSource.getTimeline(username, page, pageSize).then((value) {
        if (value.isNotEmpty) {
          for (var post in value) {
            _localDataSource.savePostMetadata(post, post.id);
          }
          return value;        
        }
        return [];
      });
      if (timeline.isNotEmpty) {
        return Right(timeline);
      } else {
        return Left(Exception("Timeline not available"));
      }
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, PostModel>> addComment(String comment, String username, String posId) async {
    try{
      final res = await _remoteDataSource.addComment(comment, username, posId);
      return Right(res);
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, bool>> addLike(String postId, String userId) async {
    try{
      final res = await _remoteDataSource.likePost(postId, userId);
      return Right(res);
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Exception, bool>> removeLike(String postId, String userId) async {
    try{
      final res = await _remoteDataSource.unlikePost(postId, userId);
      return Right(res);
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, List<PostModel>>> getAdminTimeline(int page, int pageSize) async {
    try {
      List<PostModel> timeline = await _remoteDataSource.getAdminTimeline(page, pageSize).then((value) {
        if (value.isNotEmpty) {
          for (var post in value) {
            _localDataSource.savePostMetadata(post, post.id);
          }
          return value;        
        }
        return [];
      });
      if (timeline.isNotEmpty) {
        return Right(timeline);
      } else {
        return Left(Exception("Timeline not available"));
      }
    } on Exception catch (e) {
      return Left(Exception("Timeline failed : ${e.toString()}"));
    }
  }

}