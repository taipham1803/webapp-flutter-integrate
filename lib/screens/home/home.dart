import 'dart:async';
import 'package:asim_test/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        // appBar: EmptyAppBar(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('myLocal App'),
          // backgroundColor: Colors.red,
        ),
        body: Container(
          // set the width of this Container to 100% screen width
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            // Vertically center the widget inside the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(color: Colors.purple),
                child: FlatButton(
                  color: Colors.orange,
                  padding: EdgeInsets.all(0.0),
                  child: Text(
                    'Open Taxi feature',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _navigateToTaxiFeature();
                    return;
                  },
                ),
              ),
            ],
          ),
        ));
  }

  startTimer() {
    var _duration = Duration(milliseconds: 500);
    return Timer(_duration, _requestPermission);
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

  _navigateToTaxiFeature() async {
    _requestPermission();
    Navigator.of(context).pushNamed(Routes.taxi);
    // Navigator.of(context).pushReplacementNamed(Routes.taxi);
  }
}
