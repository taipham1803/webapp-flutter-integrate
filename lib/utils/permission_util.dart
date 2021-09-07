import 'package:asim_test/utils/logger.dart';
import 'package:geolocator/geolocator.dart' as geolocatorUtil;
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> checkLocationPermissionIsGranted() async {
    bool serviceEnabled;
    geolocatorUtil.LocationPermission permission;

    serviceEnabled = await geolocatorUtil.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // L.e('Location services are disabled.');
    }

    permission = await geolocatorUtil.Geolocator.checkPermission();
    if (permission == geolocatorUtil.LocationPermission.deniedForever) {
      EmddiLogger.e('Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == geolocatorUtil.LocationPermission.denied) {
      permission = await geolocatorUtil.Geolocator.requestPermission();
      if (permission != geolocatorUtil.LocationPermission.whileInUse && permission != geolocatorUtil.LocationPermission.always) {
        EmddiLogger.e('Location permissions are denied (actual value: $permission).');
      }
    }
    EmddiLogger.e("locationWhenInUseStatus: ${await Permission.locationWhenInUse.status}");
    EmddiLogger.e("locationWhenInUseStatus: ${await Permission.locationWhenInUse.status}");
    EmddiLogger.e("locationAlways: ${await Permission.locationAlways.status}");
    if (await Permission.locationAlways.isGranted || await Permission.locationWhenInUse.isGranted) return true;
    if (await Permission.location.isPermanentlyDenied || await Permission.location.isRestricted) {
      openAppSettings();
      return false;
    }

    return await Permission.location.request().then((value) {
      print("value: $value");
      if (value == PermissionStatus.granted) {
        return true;
      }
      return false;
    });
  }
}
