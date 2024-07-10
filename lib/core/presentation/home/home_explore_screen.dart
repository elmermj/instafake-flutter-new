import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:instafake_flutter/widgets/post_image_widget.dart';
import 'package:provider/provider.dart';

class HomeExploreScreen extends StatefulWidget {
  final HomeProvider provider;
  const HomeExploreScreen({super.key, required this.provider});

  @override
  State<HomeExploreScreen> createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).getExplore();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Consumer<HomeProvider>(
      builder: (context, provider, child) => RefreshIndicator(
        onRefresh: () async => await homeProvider.getExplore(),
        child: ListView(
          children: [
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8),
              itemCount: provider.explorePosts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4
              ),
              itemBuilder: (context, index) {
                final post = provider.explorePosts[index];
                final filename = post.fileUrl.split('/').last;
            
                return SizedBox(
                  height: Get.width / 3,
                  width: Get.width / 3,
                  child: FutureBuilder<File?>(
                    future: provider.getFile(filename),
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
                        // return ClipRect(
                        //   child: FittedBox(
                        //     fit: BoxFit.cover,
                        //     child: MediaWidget(file: snapshot.data!)
                        //   ),
                        // );
                        return PostImageWidget(
                          url: SERVER_URL + post.fileUrl, width: width/3, height: height);
                      }
                    },
                  ),
                );
              },
            ),
            provider.hasMore? Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0
                  ),
                  onPressed: () async {
                    await homeProvider.getMoreExplore();
                  },
                  child: const AutoSizeText(
                    'Load More'
                  ),
                ),
              ),
            ):Container(
              padding: const EdgeInsets.all(32),
              child: const Center(
                child: AutoSizeText('No More Posts'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
