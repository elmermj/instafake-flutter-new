import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:instafake_flutter/core/data/models/suggestion_model.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate<String> {

  @override
  final String query;

  CustomSearchDelegate({super.searchFieldLabel, super.searchFieldStyle, super.searchFieldDecorationTheme, super.keyboardType, super.textInputAction, required this.query});


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Get.back(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    Log.yellow("SEARCH DELEGATE: ${context.watch<HomeProvider>().searchedUsers.length}");
    if (context.watch<HomeProvider>().searchedUsers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No users found',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Try searching for a different username',
              style: TextStyle(fontSize: 15),
            ),
          ],
        )
      );
    }
    return ListView.builder(
      itemCount: context.watch<HomeProvider>().searchedUsers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(context.read<HomeProvider>().searchedUsers[index].username),
          subtitle: Text(context.read<HomeProvider>().searchedUsers[index].name ?? ' '),
          onTap: () {
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<SuggestionModel> suggestionList = Hive.box<SuggestionModel>(SEARCH_SUGGESTIONS_KEY).values.toList();
    suggestionList.sort(
      (a,b) => a.count.compareTo(b.count)
    );

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].suggestion),
          onTap: () {
            context.read<HomeProvider>().searchController.text = suggestionList[index].suggestion;
            Get.back();
          },
        );
      },
    );
  }

}