import 'package:asim_test/screens/home/home.dart';
import 'package:asim_test/utils/permission_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiPage extends StatefulWidget {
  const TaxiPage({Key? key}) : super(key: key);

  @override
  State<TaxiPage> createState() => _TaxiPage();
}

class _TaxiPage extends State<TaxiPage> with SingleTickerProviderStateMixin {
  // to fix keyboard not show in Android 12
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String webviewUri = 'https://asim.emddi.xyz';
    final args = ModalRoute.of(context)?.settings.arguments as ScreenArguments;
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
      // to fix keyboard not show in Android 12
      initialOptions: options,
      initialUrlRequest: URLRequest(url: urlWebApp, method: 'GET'),
      onWebViewCreated: (controller) {
        webViewController = controller; // to fix keyboard not show in Android 12
        webViewController?.addJavaScriptHandler(
            handlerName: 'callBackPopScreenHandler',
            callback: (args) {
              Navigator.of(context).maybePop();
            });
        webViewController?.addJavaScriptHandler(
            handlerName: 'callBackAccessLocationPermission',
            callback: (args) {
              _checkLocationPermission();
            });
        webViewController?.addJavaScriptHandler(
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
