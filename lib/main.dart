// import 'dart:convert';
// import 'dart:typed_data';

import 'package:asim_test/utils/routes/routes.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:io';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      color: Colors.blue,
      routes: Routes.routes,
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: Routes.home,
    );
  }
}
