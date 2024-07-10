import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/providers/camera_provider.dart';
import 'package:provider/provider.dart';

class ConfirmUploadPage extends StatelessWidget {
  final String imagePath;

  const ConfirmUploadPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(File(imagePath)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await cameraProvider.uploadStory();
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}