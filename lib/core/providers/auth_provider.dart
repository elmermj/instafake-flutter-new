import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/repos/user_model_repository.dart';
import 'package:instafake_flutter/core/domain/usecases/login_usecase.dart';
import 'package:instafake_flutter/core/presentation/home/home_screen.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/enums/entry_state.dart';
import 'package:instafake_flutter/utils/log.dart';

class AuthProvider extends ChangeNotifier {
  final UserModelRepository _userModelRepository;
  EntryState state = EntryState.login;
  UserModel? user;
  AuthProvider({required UserModelRepository userModelRepository}): _userModelRepository = userModelRepository;
  
  ValueNotifier<String?> emailErrorNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String?> passwordErrorNotifier = ValueNotifier<String?>(null);

  void changeEmailErrorNotifierValue ({required String? newError}) {
    emailErrorNotifier.value = newError;
    notifyListeners();
  }

  void changePasswordErrorNotifierValue ({required String? newError}) {
    passwordErrorNotifier.value = newError;
    notifyListeners();
  }

  void changeUsername({required String newUsername}) async {
    notifyListeners();
  }

  void changeEntryState({required EntryState newEntryState}) {
    state = newEntryState;
    notifyListeners();
  }

  commitEmailRegistration(
    String name,
    String username,
    String email,
    String password
  ) async {
    try {
      final result = await _userModelRepository.register(
        name,
        username.toLowerCase(),
        email.toLowerCase(),
        password
      );

      result.fold(
        (l) {
          Get.snackbar('Registration Failed', l.toString());
        },
        (r) {
          Get.snackbar('Registration Success', 'Welcome, $username');
          Get.find<UserDataService>().userModel = r;
          Get.off(()=>const HomeScreen());
        }
      );
    } on Exception catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    }
  }

  commitEmailLogin({required String username, required String password}) async {
    Log.yellow("LOGIN INITIATED");
    var result = await LoginUseCase(_userModelRepository).login(username, password);
    result.fold(
      (result){
        Get.snackbar('Login Failed', result.toString());
      },
      (result){
        Log.green("LOGIN SUCCESSFUL, DATA ::: ${result.toJson()}");
        Get.snackbar('Login Success', 'Welcome, ${result.username}');
        Get.find<UserDataService>().userModel = result;
        Log.cyan('USER DATA TOKEN FROM LOGIN ::: ${Get.find<UserDataService>().userModel!.token}');
        Get.off(()=>const HomeScreen());
      }
    );

  }

  getMetadata(){

  }
}