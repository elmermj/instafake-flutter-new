import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryThumbnail extends StatelessWidget {
  const GalleryThumbnail({super.key, required this.asset, required this.onTap});

  final AssetEntity asset;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Positioned.fill(child: Image.memory(snapshot.data!, fit: BoxFit.cover)),
                asset.type == AssetType.video
                    ? const Center(child: Icon(Icons.play_arrow))
                    : const SizedBox.shrink(),
              ],
            ),
          );
        } else {
          return const CustomLoadingWidget();
        }
      },
    );
  }
}