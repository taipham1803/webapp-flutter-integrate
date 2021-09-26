import 'package:asim_test/screens/home/home.dart';
import 'package:asim_test/utils/permission_util.dart';
import 'package:asim_test/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:location/location.dart';

class TaxiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String envType;
    String webviewUri = 'https://asim.emddi.xyz';
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    webviewUri = args.url;
    print('Check webviewUri = ' + webviewUri);

    String access_token = "asim_access_token"; // myLocal user's jwt
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("$webviewUri?token=$access_token"), method: 'GET'),
      // initialUrlRequest: URLRequest(url: Uri.parse("http://localhost:9106?token=$access_token"), method: 'GET'),
      onWebViewCreated: (controller) {
        controller.addJavaScriptHandler(
            handlerName: 'callBackPopScreenHandler',
            callback: (args) {
              print('Check goBack');
              Navigator.of(context).maybePop();
            });
        controller.addJavaScriptHandler(
            handlerName: 'callBackAccessLocationPermission',
            callback: (args) {
              _checkLocationPermission();
            });
      },
      // handle permission request prompt android
      androidOnGeolocationPermissionsShowPrompt: (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(origin: origin, allow: true, retain: true);
      },
        // _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
        //   if (mounted) {
        //     setState(() {
        //       _history.add("onUrlChanged: $url");
        //     });
        //     if(url.contains("tel")){
        //       //implement for condition
        //     }
        //   }
        // });
      onConsoleMessage: (controller, consoleMessage) {
        print('Check onConsoleMessage');
        print(consoleMessage);
      },
    );
  }

  Future<bool> _checkLocationPermission() async {
    return await PermissionUtil.checkLocationPermissionIsGranted();
  }

  _requestPermission() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }
}
