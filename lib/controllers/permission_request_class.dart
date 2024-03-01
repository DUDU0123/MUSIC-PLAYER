import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestClass {
  // requesting permission to access storage for delete
  static Future<bool> permissionStorageToDelete() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var deviceInfo = await deviceInfoPlugin.androidInfo;
    PermissionStatus permissionStatus;
    if (int.parse(deviceInfo.version.release) < 11) {
      permissionStatus = await Permission.storage.request();
    } else {
      permissionStatus = await Permission.manageExternalStorage.request();
    }
    return permissionStatus.isGranted;
  }


  // requesting permission to access storage
  static Future<bool> permissionStorage() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    var k = await deviceInfoPlugin.androidInfo;
    PermissionStatus permissionStatus;
    if (int.parse(k.version.release) < 13) {
      //if it is android version below 13 then asking for storage permission
      permissionStatus = await Permission.storage.request();
    } else {
      //if it is android 13 or above asking video permission
      permissionStatus = await Permission.audio.request();
    }
    return permissionStatus.isGranted;
  }
}