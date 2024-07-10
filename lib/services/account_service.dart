import 'package:camera/camera.dart';
import 'package:get/get.dart';

class DeviceStatusService extends GetxService{
  RxBool isLogin = false.obs;
  RxBool permissionsGranted = false.obs;
  late CameraController controller;
  List<CameraDescription> cameras = <CameraDescription>[];

  bool isAdmin = false;

  @override
  Future<void> onInit() async {
    super.onInit();
  }
}