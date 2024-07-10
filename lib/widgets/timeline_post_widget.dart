import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/post_model.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/presentation/home/home_post_detail_screen.dart';
import 'package:instafake_flutter/core/presentation/profile/profile_user_screen.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/widgets/caption_widget.dart';
import 'package:instafake_flutter/widgets/post_image_widget.dart';
import 'package:instafake_flutter/widgets/profile_handler_widget.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:timeago/timeago.dart';

class TimelinePostWidget extends StatelessWidget {
  const TimelinePostWidget({
    super.key,
    required this.width,
    required this.post,
    required this.height,
    required this.homeProvider,
    required this.userData,
    required this.isLiked, required this.index,
  });

  final double width;
  final PostModel post;
  final double height;
  final HomeProvider homeProvider;
  final UserModel userData;
  final bool isLiked;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileHandlerWidget(
            picUrl: post.creatorProfPicUrl,
            username: post.creatorUsername,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () async => isLiked 
              ? await homeProvider.removeLike(post.id.toString(),userData.id.toString(), index)
              : await homeProvider.addLike(post.id.toString(),userData.id.toString(), index),
                child: PostImageWidget(url: SERVER_URL + post.fileUrl, width: width, height: height)
              ),
            ],
          ),
          SizedBox(
            width: width,
            height: 45,
            child: Row(
              children: [
                IconButton(
                  onPressed: () async => isLiked 
                ? await homeProvider.removeLike(post.id.toString(),userData.id.toString(), index)
                : await homeProvider.addLike(post.id.toString(),userData.id.toString(), index),
                  icon: Icon(isLiked? Icons.favorite: Icons.favorite_border_outlined,)
                ),
                IconButton(
                  onPressed: () {
                    homeProvider.currentPost = post;
                    Get.to(() => HomePostDetailScreen(post: post,));
                  },
                  icon: const Icon(LucideIcons.messageCircle))
              ],
            ),
          ),
          Container(
            width: width,
            padding:const EdgeInsets.symmetric(horizontal: 8),
            child: Text(post.likeUserIds!.isEmpty? 'No one has liked this post': "${post.likeUserIds!.length.toString()} likes",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                post.isCaptionExpanded!
              ? CaptionWidget(
                  caption: post.caption,
                  username: post.creatorUsername,
                  onUsernameTap: (p0) {
                    Get.to(() => ProfileUserScreen(username: p0,));
                  },
                )
              : CaptionWidget(
                  caption: post.caption,
                  username: post.creatorUsername,
                  onUsernameTap: (p0) {
                    Get.to(() => ProfileUserScreen(username: p0,));
                  },
                  maxLines: 10,
                ),
                if (post.caption.split('\n').length > 3)
                TextButton(
                  onPressed: () {
                    homeProvider.toggleCaptionExpansion(index);
                  },
                  child: Text(
                    post.isCaptionExpanded!
                  ? "Show less"
                  : "Show more",
                  ),
                ),
              ],
            ),
          ),
          post.comments!.length > 2
        ? TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            onPressed: () {
              homeProvider.toggleCommentExpansion(index);
            },
            child: Text(post.isCommentExpanded!? "Show less": "Show ${(post.comments!.length - 2)} more comments",),
          )
        : const SizedBox.shrink(),
    
          if(post.comments!.isNotEmpty && post.comments != null)
          post.isCommentExpanded!
        ? SizedBox(
            width: width,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: post.comments!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, commentIndex) {
                final comment = post.comments![commentIndex];
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ProfileHandlerWidget(
                      username: comment.author,
                      picUrl: comment.commenterProfPic,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.comment,
                      textAlign: TextAlign.right,
                    )
                  ],
                );
              },
            ),
          )
        : SizedBox(
            width: width,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: post.comments!.length < 2 ? 1 : 2,
              itemBuilder: (context, commentIndex) {
                final comment = post.comments![commentIndex];
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ProfileHandlerWidget(
                      username: comment.author,
                      picUrl: comment.commenterProfPic,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      comment.comment,
                      textAlign: TextAlign.right,
                    )
                  ],
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: width,
            child: Text(
              format(post.createdAt),
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }
}
