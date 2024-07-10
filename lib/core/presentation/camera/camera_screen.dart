import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:instafake_flutter/core/providers/camera_provider.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:instafake_flutter/widgets/custom_loading_widget.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CameraProvider>(context, listen: false).initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context, listen: true);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Log.yellow("BUILD START");
    if (cameraProvider.isLoading) {
      return const Center(child: CustomLoadingWidget());
    } else if (cameraProvider.controller?.value != null && cameraProvider.controller!.value.isInitialized) {
      return Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Container(              
              height: height,
              width:  width,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, kBottomNavigationBarHeight/1.5),
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CameraPreview(cameraProvider.controller!)
                )
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0, 0.85),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () async {
                try {
                  final image = await cameraProvider.controller!.takePicture();
                  final imagePath = await cameraProvider.savePicture(image);
                  cameraProvider.setImage(imagePath);
                } catch (e) {
                  Log.red(e.toString());
                }
              },
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.9, 0.85),
            child: IconButton(
              onPressed: () async => cameraProvider.changeCamera(),
              icon: const Icon(Icons.refresh),
            ),
          ),
        ],
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}