import 'package:asim_test/screens/home/home.dart';
import 'package:asim_test/screens/taxi/taxi.dart';
import 'package:flutter/material.dart';

class Routes {
  Routes._();
  static const String home = '/home';
  static const String taxi = '/taxi';

  static final routes = <String, WidgetBuilder>{
    home: (BuildContext context) => HomeScreen(),
    taxi: (BuildContext context) => TaxiPage(),
  };
}
