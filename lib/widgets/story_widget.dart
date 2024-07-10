
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/domain/dto/story_response.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/widgets/post_image_widget.dart';
import 'package:timeago/timeago.dart';

class StoryWidget extends StatelessWidget {
  const StoryWidget({
    super.key,
    required this.width,
    required this.story,
  });

  final double width;
  final StoryResponse story;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width/4, width: width/4,
      margin: const EdgeInsets.only(right: 16),
      child: AspectRatio(
        aspectRatio:9/16,
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PostImageWidget(url: SERVER_URL+story.storyUrl, height: width/4, width: width/4, fit: BoxFit.cover)
              )
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: double.maxFinite,
                  width:  double.maxFinite,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const  EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AutoSizeText(
                      story.storyAuthor,
                      minFontSize: 6,
                      maxFontSize: 12,
                        
                    ),
                    AutoSizeText(
                      format(story.createdAt),
                      minFontSize: 4,
                      maxFontSize: 8,
                        
                    ),
                  ],
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}