import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/core/providers/profile_provider.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:instafake_flutter/widgets/post_image_widget.dart';
import 'package:instafake_flutter/widgets/profile_bar.dart';
import 'package:instafake_flutter/widgets/profile_counts_widget.dart';
import 'package:provider/provider.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key, 
    required this.username
  });

  final String username;

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).getUserProfile(widget.username);
  }
  final UserModel userData = Get.find<UserDataService>().userDataBox.get(METADATA_KEY)!;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final profileProvider = Provider.of<ProfileProvider>(context);
    Log.green("MY ID ::: ${userData.id} ||| OTHERS ID ::: ${profileProvider.userProfile.id}");

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username
        ),
      ),
      body: profileProvider.isLoading == false
    ? RefreshIndicator(
        onRefresh: () async => await profileProvider.getUserProfile(widget.username),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: width /5,
                        width: width /5,
                        child: Stack(
                          children: [
                            Center(
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(
                                  profileProvider.userProfile.profImageUrl != null && profileProvider.userProfile.profImageUrl!.isNotEmpty? 
                                  SERVER_URL+profileProvider.userProfile.profImageUrl!
                                  :
                                  "https://picsum.photos/200/300",
                                ),
                              ),
                            ),
                            profileProvider.userProfile.id == userData.id? Align(
                              alignment: const AlignmentDirectional(1,1),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: IconButton.filled(
                                  alignment: Alignment.center,
                                  onPressed: (){},
                                  icon: const Center(
                                    child: Icon(
                                      Icons.add, size: 16, weight: 100,
                                    )
                                  )
                                ),
                              ),
                            ):const SizedBox.shrink()
                          ],
                        ),
                      ),
                      ProfileCountsWidget(count: profileProvider.userProfile.thumbnails == null? 0 : profileProvider.userProfile.thumbnails!.length, label: "posts",),
                      ProfileCountsWidget(count: profileProvider.userProfile.followers.length, label: "followers",),                  
                      ProfileCountsWidget(count: profileProvider.userProfile.followings.length, label: "following",)
                    ]
                  ),
                  const SizedBox(height: 8,),
                  AutoSizeText(
                    profileProvider.userProfile.name!,
                    minFontSize: 12,
                    maxFontSize: 20,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                  AutoSizeText(
                    profileProvider.userProfile.username,
                    minFontSize: 10,
                    maxFontSize: 15,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12
                    ),
                  ),                
                  AutoSizeText(
                    profileProvider.userProfile.bio==null || profileProvider.userProfile.bio!.isEmpty ? "No bio" : profileProvider.userProfile.bio!,
                    minFontSize: 10,
                    maxFontSize: 15,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12
                    ),
                    maxLines: 5,
                  ),
                  profileProvider.isFollowLoading
                ? const CustomLoadingWidget()
                : ProfileBar(
                    isMe: widget.username == userData.username,
                    isFollowed: profileProvider.userProfile.followers.contains(userData.id),
                    follow: ()=> profileProvider.follow(userData.id),
                    unfollow: ()=> profileProvider.unfollow(userData.id),
                    editProfile: () => Provider.of<HomeProvider>(context).commitLogout(),
                  )
                ],
              ),      
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8),
              itemCount: profileProvider.userProfile.thumbnails?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4
              ),
              itemBuilder: (context, index) {
                final post = profileProvider.userProfile.thumbnails![index];
                return PostImageWidget(url: SERVER_URL + post.fileUrl, width: Get.width / 3, height: Get.width / 3);
              },
            ),
          ]
        ),
      ): const Center(
        child:  CustomLoadingWidget(),
      )
    );
  }
}

