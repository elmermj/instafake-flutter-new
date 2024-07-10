import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/utils/constants.dart';

class UserDataService extends GetxService{
  UserModel? userModel;
  final Box<UserModel> userDataBox;

  UserDataService(this.userDataBox);

  @override
  void onInit() {
    super.onInit();
    userModel = userDataBox.get(METADATA_KEY);
  }
}