import 'package:dartz/dartz.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/repos/user_model_repository.dart';
import 'package:instafake_flutter/utils/log.dart';

class LoginUseCase {
  final UserModelRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Exception, UserModel>> login(String username, String password) async {
    Log.yellow("LOGIN USE CASE INITIATED");
    return await repository.login(username, password);
  }

}
