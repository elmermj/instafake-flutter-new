import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:instafake_flutter/core/data/models/suggestion_model.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/presentation/auth/auth_screen.dart';
import 'package:instafake_flutter/utils/constants.dart';

class LocalUserModelDataSource {
  final Box<UserModel> userMetadataBox;
  final Box<SuggestionModel> suggestionsBox; 

  LocalUserModelDataSource(this.userMetadataBox, this.suggestionsBox);

  Future<void> saveUserMetadata(UserModel response) async {
    await userMetadataBox.put(METADATA_KEY, response);
  }

  UserModel? getUserMetadata() {
    return userMetadataBox.get(METADATA_KEY);
  }

  Future<void> clearUserMetadata() async {
    await userMetadataBox.delete(METADATA_KEY);
    Get.off(()=>AuthScreen());
  }

  Future<void> saveSuggestions(String query) async {
    if(suggestionsBox.containsKey(query)){
      SuggestionModel suggestion = suggestionsBox.get(query)!;

      suggestion.count++;
      suggestion.lastUpdated = DateTime.now();
    }else {
      await suggestionsBox.put(query, SuggestionModel(
        count: 1,
        lastUpdated: DateTime.now(),
        suggestion: query
      ));
    }
  }
}