import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/empty_timeline_notice.dart';
import 'package:instafake_flutter/widgets/story_widget.dart';
import 'package:instafake_flutter/widgets/timeline_post_widget.dart';
import 'package:provider/provider.dart';

class HomeTimelineScreen extends StatefulWidget {
  final HomeProvider provider;
  final UserModel? userData;
  const HomeTimelineScreen({
    super.key,
    required this.userData,
    required this.provider,
  });

  @override
  State<HomeTimelineScreen> createState() => _HomeTimelineScreenState();
}

class _HomeTimelineScreenState extends State<HomeTimelineScreen> {
  late final UserModel userData;

  @override
  void initState() {
    super.initState();
    userData = Get.find<UserDataService>().userDataBox.get(METADATA_KEY)!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    if(userData.role == 'ADMIN'){
      Log.yellow("USER ROLE ::: ${userData.role}");
      await widget.provider.getAdminTimeline();
    } else {
      await widget.provider.getTimeline(userData.username);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);

    return homeProvider.posts.isEmpty


  ? RefreshIndicator(
      onRefresh: () async =>
          userData.role == 'ADMIN'? await homeProvider.getAdminTimeline(): homeProvider.getTimeline(userData.username),
      child: const Center(
        child: EmptyTimelineNotice(),
      ),
    )



  : RefreshIndicator(
      onRefresh: () async => userData.role == 'ADMIN'? await homeProvider.getAdminTimeline(): homeProvider.getTimeline(userData.username),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: width,
              height: height / 5,
              margin: const EdgeInsets.all(8),
              child: homeProvider.stories.isEmpty
            ? const Center(
                child: Text(
                  "No stories yet",
                  style: TextStyle(fontSize: 20),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: homeProvider.stories.length,
                itemBuilder: (context, index) {
                  final story = homeProvider.stories[index];
                  return StoryWidget(width: width, story: story);
                },
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: homeProvider.posts.length + (homeProvider.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == homeProvider.posts.length && homeProvider.posts.isNotEmpty) {
                  if (homeProvider.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  } else {
                    return const Center(
                      child: Text('No more posts'),
                    );
                  }
                }
                final post = homeProvider.posts[index];
                bool isLiked = post.likeUserIds!=null? post.likeUserIds!.contains(userData.id): false;


                return TimelinePostWidget(
                  width: width, 
                  post: post,
                  height: height, 
                  homeProvider: homeProvider, 
                  userData: userData, 
                  isLiked: isLiked,
                  index: index
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

