import 'package:asim_test/screens/home/home.dart';
import 'package:asim_test/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String webviewUri = 'https://asim.emddi.xyz';
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    webviewUri = args.url;

    String access_token = "asim_access_token"; // myLocal user's jwt
    String notify_id = "emddi_notify_id"; // notifyId retrieved from notify's data
    String trip_id = "emddi_trip_id_in_notify"; // tripId retrieved from notify's data

    // device orientation force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    var urlWebApp = Uri.parse("$webviewUri?token=$access_token&notifyId=$notify_id&tripId=$trip_id");

    return InAppWebView(
      initialUrlRequest: URLRequest(url: urlWebApp, method: 'GET'),
      onWebViewCreated: (controller) {
        controller.addJavaScriptHandler(
            handlerName: 'callBackPopScreenHandler',
            callback: (args) {
              Navigator.of(context).maybePop();
            });
        controller.addJavaScriptHandler(
            handlerName: 'callBackAccessLocationPermission',
            callback: (args) {
              _checkLocationPermission();
            });
        controller.addJavaScriptHandler(
            handlerName: 'makeCall',
            callback: (args) {
              Map<String, dynamic> json = args[0];
              String phone = json['phoneNumber'].toString().replaceAll(' ', '');
              launch("tel://$phone");
              return {'makeCall callback:': 'success!'};
            });
      },
      // handle permission request prompt android
      androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(origin: origin, allow: true, retain: true);
      },
    );
  }

  Future<bool> _checkLocationPermission() async {
    return await PermissionUtil.checkLocationPermissionIsGranted();
  }
}
