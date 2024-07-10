import 'package:hive/hive.dart';

part 'suggestion_model.g.dart';

@HiveType(typeId: 3)
class SuggestionModel {
  @HiveField(0)
  String suggestion;
  @HiveField(1)
  DateTime lastUpdated;
  @HiveField(2)
  int count;

  SuggestionModel({required this.suggestion, required this.lastUpdated, required this.count});
}