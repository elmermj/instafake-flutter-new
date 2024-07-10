import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instafake_flutter/core/data/models/user_model.dart';
import 'package:instafake_flutter/core/domain/dto/create_post_request.dart';
import 'package:instafake_flutter/core/domain/repos/post_model_repository.dart';
import 'package:instafake_flutter/core/domain/repos/story_model_repository.dart';
import 'package:instafake_flutter/core/presentation/camera/camera_story_confirmation.dart';
import 'package:instafake_flutter/core/presentation/home/home_screen.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/constants.dart';
import 'package:instafake_flutter/utils/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;

class CameraProvider extends ChangeNotifier {
  final PostModelRepository _postRepo;
  final StoryModelRepository _storyRepo;
  late String _imagePath;
  UserModel userData = Get.find<UserDataService>().userDataBox.get(METADATA_KEY)!;

  CameraProvider({
    required PostModelRepository postModelRepository, required StoryModelRepository storyModelRepository
  }) : _postRepo = postModelRepository, _storyRepo = storyModelRepository;

  String get imagePath => _imagePath;

  List<CameraDescription> cameras = <CameraDescription>[];
  TextEditingController captionEditController = TextEditingController();
  int cameraIndex = 0;
  CameraController? controller;
  bool isLoading = false; // overall loading state
  bool isImageLoading = false; // selected image loading state
  List<AssetEntity> assets = [];
  List<AssetPathEntity> albums = [];
  int selectedAlbumIndex = 0;
  int pageIndex = 0;

  AssetEntity? _selectedAsset;
  Future<File?>? get selectedFile => _selectedAsset?.file;

  
  String pathToStory = '';
  late File storyFile;

  void setImage(String input) {
    _imagePath = input;
    notifyListeners();
  }

  Future<void> initializeCamera() async {
    isLoading = true;
    try {
      cameras = await availableCameras();
      controller = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.veryHigh,
      );
      Log.green("CAMERAS LENGTH ::: ${cameras.length}");
      await controller!.initialize();
      isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      Log.red(e.toString());
      isLoading = false;
      notifyListeners();
    }
  }

  void changeCamera() async {
    isLoading = true;
    notifyListeners();
    if (cameras.length > 1) {
      cameraIndex = (cameraIndex + 1) % cameras.length;
      controller = CameraController(
        cameras[cameraIndex],
        ResolutionPreset.veryHigh,
      );
      await controller!.initialize().then((value) {
        Log.green("CAMERA CHANGED ::: SUCCESS");
        isLoading = false;
        notifyListeners();
      }).catchError((e) {
        isLoading = false;
        notifyListeners();
        Log.red(e.toString());
      });
    }
  }

  Future<String> savePicture(XFile media) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final String capturesDirPath = path.join(appDir.path, 'captures');
      
      final Directory capturesDir = Directory(capturesDirPath);
      if (!await capturesDir.exists()) {
        await capturesDir.create(recursive: true);
      }

      final String newFilePath = path.join(capturesDirPath, '${DateTime.now().millisecondsSinceEpoch}.jpg');
      // final File newFile = File(newFilePath);

      final File copiedFile = await File(media.path).copy(newFilePath);
      Get.to(()=>ConfirmUploadPage(imagePath: imagePath));
      storyFile = copiedFile;
      pathToStory = copiedFile.path;
      notifyListeners();
      return pathToStory;
    } catch (e) {
      Log.red('Error saving picture: $e');
      return e.toString();
    }
  }

  Future<void> uploadStory() async {
    try {

      final result = await _storyRepo.createStory(userData.username, storyFile);

      result.fold(
        (e){
          Get.snackbar(
            "Error",
            e.toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        (r){
          Get.snackbar(
            "Success",
            "Story uploaded successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      );
      Get.offAll(()=>const HomeScreen());
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    }
  }


  fetchGalleryAndAlbums() async {
    isLoading = true;
    // notifyListeners();
    albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    Log.yellow("ALBUMS COUNT ::: ${albums.length}");
    if (albums.isNotEmpty) {
      await selectAlbum(0);
    }
    isLoading = false;
    notifyListeners();
    Log.green("DONE");
  }

  selectAlbum(int index) async {
    selectedAlbumIndex = index;
    isLoading = true;
    notifyListeners();
    int total = await albums[index].assetCountAsync;
    Log.yellow("ASSETS COUNT ::: $total");
    assets = await albums[index].getAssetListPaged(page: 0, size: total);
    if (assets.isNotEmpty) {
      _selectedAsset = assets.first;
    }
    isLoading = false;
    notifyListeners();
  }

  void chooseAsset(AssetEntity inputAsset) async {
    isImageLoading = true;
    notifyListeners();
    _selectedAsset = inputAsset;
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate loading time
    isImageLoading = false;
    notifyListeners();
  }

  void togglePageIndex() {
    pageIndex = (pageIndex + 1) % 2;
    notifyListeners();
  }

  createPost() async {

    final request = CreatePostRequest(username: userData.username, caption: captionEditController.text);
    final File uploadFile =  await _selectedAsset!.file.then((onValue)=>onValue!);
    try {
      final result = await _postRepo.createPost(request, uploadFile);

      result.fold(
        (exception)=>Get.snackbar('Error', 'Post creation failed: $exception')
        ,
        (notice) {
          Get.back();
          return Get.snackbar('Success', 'You have uploaded a new post');
        }
      );

    } catch (e) {
      Get.snackbar('Error', 'Exception: $e');
    }
  }
}

