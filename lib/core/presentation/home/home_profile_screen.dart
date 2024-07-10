import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:instafake_flutter/widgets/media_widget.dart';
import 'package:instafake_flutter/widgets/profile_counts_widget.dart';
import 'package:provider/provider.dart';

class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({super.key});

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getMyProfile();
  }

  @override
  Widget build(BuildContext context) {

    final homeProvider = Provider.of<HomeProvider>(context, listen: true);

    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        if (homeProvider.isLoading == false) {
          return RefreshIndicator(
            onRefresh: () async => await homeProvider.getMyProfile(),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  width: Get.width,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: Get.width /5,
                            width: Get.width /5,
                            child: Stack(
                              children: [
                                Center(
                                  child: CircleAvatar(
                                    radius: 48,
                                    backgroundImage: NetworkImage(
                                      value.myProfile.profImageUrl != null && value.myProfile.profImageUrl!.isNotEmpty? 
                                      SERVER_URL+value.myProfile.profImageUrl!
                                      :
                                      "https://picsum.photos/200/300",
                                    ),
                                  ),
                                ),
                                Align(
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
                                )
                              ],
                            ),
                          ),
                          ProfileCountsWidget(count: value.myProfile.thumbnails == null? 0 : value.myProfile.thumbnails!.length, label: "posts",),
                          ProfileCountsWidget(count: value.myProfile.followers.length, label: "followers",),                  
                          ProfileCountsWidget(count: value.myProfile.followings.length, label: "following",)
                        ]
                      ),
                      const SizedBox(height: 8,),
                      AutoSizeText(
                        value.myProfile.name!,
                        minFontSize: 12,
                        maxFontSize: 20,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                      AutoSizeText(
                        value.myProfile.username,
                        minFontSize: 10,
                        maxFontSize: 15,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12
                        ),
                      ),                
                      AutoSizeText(
                        value.myProfile.bio==null || value.myProfile.bio!.isEmpty ? "No bio" : value.myProfile.bio!,
                        minFontSize: 10,
                        maxFontSize: 15,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12
                        ),
                        maxLines: 5,
                      ),
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  side: BorderSide(
                                    color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                                    width: 1
                                  ),
                                ),
                                onPressed: (){}, 
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                  ),
                                )
                              ),
                            ),
                            const SizedBox(width: 16,),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  side: BorderSide(
                                    color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                                    width: 1
                                  ),
                                  backgroundColor: Get.theme.colorScheme.error
                                ),
                                onPressed: (){
                                  homeProvider.commitLogout();
                                }, 
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),      
                ),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: value.myProfile.thumbnails == null? 0 : value.myProfile.thumbnails!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4
                  ),
                  itemBuilder: (context, index) {
                    final post = value.myProfile.thumbnails![index];
                    final filename = post.fileUrl.split('/').last;
                
                    return SizedBox(
                      height: Get.width / 3,
                      width: Get.width / 3,
                      child: FutureBuilder<File?>(
                        future: value.getFile(filename),
                        builder: (context, snapshot) {
                          Log.yellow("HomeExploreScreen: ${snapshot.connectionState}");
                          Log.yellow("HomeExploreScreen: ${snapshot.data?.length().toString()}");
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CustomLoadingWidget());
                          }                  
                          else if (snapshot.hasError || snapshot.data == null) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.error),
                                  AutoSizeText(
                                    '${post.postId}\n${post.caption}',
                                    minFontSize: 6,
                                    maxFontSize: 10,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            );
                          }
                          else {
                            return ClipRect(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: MediaWidget(file: snapshot.data!)
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                // value.profileHasMore? Container(
                //   padding: const EdgeInsets.all(16),
                //   child: Center(
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         elevation: 0
                //       ),
                //       onPressed: () async {
                //         await value.getMoreExplore();
                //       },
                //       child: const AutoSizeText(
                //         'Load More'
                //       ),
                //     ),
                //   ),
                // ):Container(
                //   padding: const EdgeInsets.all(32),
                //   child: const Center(
                //     child: AutoSizeText('No More Posts'),
                //   ),
                // )
              ]
            ),
          );
        }else {
          return const Center(
            child:  CustomLoadingWidget(),
          );
        }
      },
    );
  }
}

