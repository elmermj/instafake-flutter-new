import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:instafake_flutter/core/data/sources/remote_story_model_data_source.dart';
import 'package:instafake_flutter/core/domain/dto/story_response.dart';

abstract class StoryModelRepository {
  Future<Either<Exception, List<StoryResponse>>> getStories();
  Future<Either<Exception, void>> createStory(String username, File file);
}

class StoryModelRepositoryImple implements StoryModelRepository {
  final RemoteStoryModelDataSource _remoteDataSource;

  StoryModelRepositoryImple({required RemoteStoryModelDataSource remoteDataSource}) : _remoteDataSource = remoteDataSource;
  
  @override
  Future<Either<Exception, void>> createStory(String username, File file) async {
    try {
      await _remoteDataSource.createStory(username, file);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Exception("Create story failed : ${e.toString()}"));
    }
  }
  
  @override
  Future<Either<Exception, List<StoryResponse>>> getStories() async {
    try {
      final response = await _remoteDataSource.getStories();
      return Right(response);
    } on Exception catch (e) {
      return Left(Exception("Create story failed : ${e.toString()}"));
    }
  }
}