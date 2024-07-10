import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:video_player/video_player.dart';

class MediaWidget extends StatefulWidget {
  final File file;

  const MediaWidget({super.key, required this.file});

  @override
  MediaWidgetState createState() => MediaWidgetState();
}

class MediaWidgetState extends State<MediaWidget> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();Log.yellow("FILE PATH IN MEDIA WIDGET ::: ${widget.file.path}");
    if (isVideo(widget.file.path)) {
      _controller = VideoPlayerController.file(widget.file)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool isVideo(String path) {
    Log.yellow(path);
    final videoExtensions = ['mp4', 'mov', 'wmv', 'avi', 'mkv', 'flv', 'webm'];
    final extension = path.split('.').last.toLowerCase();
    return videoExtensions.contains(extension);
  }

  @override
  Widget build(BuildContext context) {
    if (isVideo(widget.file.path) && _controller != null && _controller!.value.isInitialized) {
      return VideoPlayer(_controller!);
    } else {
      return Image.file(widget.file);
    }
  }
}