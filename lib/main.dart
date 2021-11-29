// import 'dart:convert';
// import 'dart:typed_data';

import 'package:asim_test/utils/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: Colors.blue,
      routes: Routes.routes,
      initialRoute: Routes.home,
    );
  }
}
