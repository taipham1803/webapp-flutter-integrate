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
    if (permission == geolocatorUtil.LocationPermission.deniedForever) {}

    if (permission == geolocatorUtil.LocationPermission.denied) {
      permission = await geolocatorUtil.Geolocator.requestPermission();
      if (permission != geolocatorUtil.LocationPermission.whileInUse && permission != geolocatorUtil.LocationPermission.always) {}
    }

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
