import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/presentation/profile/profile_user_screen.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeSearchScreen extends StatelessWidget {
  const HomeSearchScreen({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(

      builder: (context, value, _) => 
      value.searchedUsers.isEmpty?const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No users found',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ):
      ListView.builder(
        itemCount: context.watch<HomeProvider>().searchedUsers.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: ()=> Get.to(()=>ProfileUserScreen(username: context.watch<HomeProvider>().searchedUsers[index].username,)),
            child: ListTile(
              leading: value.searchedUsers[index].profImageUrl==null?
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                )
                :
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(value.searchedUsers[index].profImageUrl!),
                ),
              title: Text(value.searchedUsers[index].username),
              subtitle: Text(value.searchedUsers[index].name!),
            ),
          );
        },  
      ),
    );
  }
}