import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/providers/camera_provider.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:instafake_flutter/widgets/custom_text_field.dart';
import 'package:instafake_flutter/widgets/gallery_thumbnail.dart';
import 'package:provider/provider.dart';

class CameraGalleryScreen extends StatefulWidget {
  const CameraGalleryScreen({super.key});

  @override
  State<CameraGalleryScreen> createState() => _CameraGalleryScreenState();
}

class _CameraGalleryScreenState extends State<CameraGalleryScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CameraProvider>(context, listen: false).fetchGalleryAndAlbums();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final cameraProvider = Provider.of<CameraProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create a post'
        ),
        actions: cameraProvider.pageIndex ==1 
      ? [
          TextButton(
            onPressed: ()=>cameraProvider.createPost(), 
            child: Text(
              "Done",
              style: TextStyle(
                color: colorScheme.primaryContainer,
                fontWeight: FontWeight.bold,
              )
            )
          )
        ]
      : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: cameraProvider.isImageLoading || cameraProvider.assets.isEmpty
          ? const CustomLoadingWidget()
          : FutureBuilder<File?>(
              future: cameraProvider.selectedFile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadingWidget();
                } else if (snapshot.hasData && snapshot.data != null) {
                  return Image.file(snapshot.data!, fit: BoxFit.cover);
                } else {
                  return const Text('No preview available');
                }
              },
            ),
          ),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cameraProvider.albums.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: () {
                    cameraProvider.selectAlbum(index);
                  },
                  child: Text(
                    cameraProvider.albums[index].name,
                    style: TextStyle(
                      fontSize: cameraProvider.selectedAlbumIndex == index?12:10,
                      color: cameraProvider.selectedAlbumIndex == index? colorScheme.primaryContainer : colorScheme.onSurface,
                      fontWeight: cameraProvider.selectedAlbumIndex == index?FontWeight.bold:FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: cameraProvider.isLoading
          ? const CustomLoadingWidget()
          : cameraProvider.pageIndex == 0? GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: cameraProvider.assets.length,
              itemBuilder: (context, index) {
                return GalleryThumbnail(
                  asset: cameraProvider.assets[index],
                  onTap: () {
                    cameraProvider.chooseAsset(cameraProvider.assets[index]);
                  },
                );
              },
            ): Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: CustomTextField(
                  controller: cameraProvider.captionEditController,
                  hintText: "Add a caption",
                  color: colorScheme.onSurface,
                  filled: true,
                  maxLines: 20,
                ),
              )
            ),
          ),
        ],
      ),
      bottomNavigationBar: TextButton(
        onPressed: ()=> cameraProvider.togglePageIndex(),
        child: Text(
          cameraProvider.pageIndex == 0?'Pick this one': 'Go back'
        ),
      ),
    );
  }
}