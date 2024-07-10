import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/caption_widget.dart';
import 'package:instafake_flutter/widgets/post_image_widget.dart';
import 'package:instafake_flutter/widgets/profile_handler_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart';

class HomePostDetailScreen extends StatefulWidget {
  const HomePostDetailScreen({super.key, required this.post});

  final PostModel post;

  @override
  State<HomePostDetailScreen> createState() => _HomePostDetailScreenState();
}

class _HomePostDetailScreenState extends State<HomePostDetailScreen> {
  final userData = Get.find<UserDataService>().userDataBox.get(METADATA_KEY);
  final ScrollController _scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final homeProvider = Provider.of<HomeProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Detail"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileHandlerWidget(
                    picUrl: homeProvider.currentPost!.creatorProfPicUrl, 
                    username: homeProvider.currentPost!.creatorUsername,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      PostImageWidget(
                        url: SERVER_URL + homeProvider.currentPost!.fileUrl, 
                        width: width, 
                        height: height
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    height: 45,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){}, 
                          icon: Icon(
                            homeProvider.currentPost!.likeUserIds!.contains(userData?.id)
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          )
                        ),
                        IconButton(
                          onPressed: (){}, 
                          icon: const Icon(LucideIcons.messageCircle)
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: width,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      homeProvider.currentPost!.likeUserIds!.isEmpty
                          ? 'No one has liked this post'
                          : homeProvider.currentPost!.likeUserIds!.length.toString(),
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: width,
                    child: CaptionWidget(
                      caption : homeProvider.currentPost!.caption,
                      username: homeProvider.currentPost!.creatorUsername,
                      onUsernameTap: (username){},
                    ),
                  ),
                  homeProvider.currentPost!.comments!.isEmpty
                      ? const SizedBox.shrink()
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: homeProvider.currentPost!.comments!.length,
                          itemBuilder: (context, index) {
                            final comment = homeProvider.currentPost!.comments![index];
                            return SizedBox(
                              width: double.infinity,
                              child: ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ProfileHandlerWidget(
                                          username: comment.author,
                                          picUrl: comment.commenterProfPic,
                                        ),
                                        const SizedBox(width: 8), // Add some space between widgets
                                        Expanded(
                                          child: Text(
                                            comment.comment,
                                            maxLines: 20,
                                            overflow: TextOverflow.visible, // Allow text to wrap
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        format(comment.timestamp),
                                        textAlign: TextAlign.right,
                                        minFontSize: 6,
                                        maxFontSize: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  //post timestamp
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: width,
                    child: Text(
                      format(widget.post.createdAt),
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8,0,8,kBottomNavigationBarHeight/4),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.5)
              )
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: TextField(
                    controller: homeProvider.commentEditingController,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: "Add a comment for ${widget.post.creatorUsername}...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () async {
                      Log.yellow(homeProvider.commentEditingController.text);
                      await homeProvider.addComment(
                        homeProvider.commentEditingController.text, 
                        userData!.username, 
                        widget.post.id.toString()
                      );
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }, 
                    icon: const Icon(Icons.send,)
                  )
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
