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
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        // appBar: EmptyAppBar(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('myLocal App'),
          backgroundColor: Colors.orange,
        ),
        body: Container(
          // set the width of this Container to 100% screen width
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            // Vertically center the widget inside the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonCenter('Development version', Colors.orange, () {
                _navigateToTaxiFeature('dev', 'https://asim.emddi.xyz');
                return;
              }),
              ButtonCenter('Production version', Colors.blueAccent, () {
                _navigateToTaxiFeature('prod', 'https://apim.mylocal.vn/apipayment/mylocal/1.0');
                return;
              }),
            ],
          ),
        ));
  }

  Widget ButtonCenter(String name, Color color, Function onPress) {
    return Container(
      height: 50,
      width: 200,
      margin: new EdgeInsets.symmetric(vertical: 20.0),
      child: FlatButton(
        color: color,
        padding: EdgeInsets.all(0.0),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: onPress,
      ),
    );
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

  _navigateToTaxiFeature(String envType, String url) async {
    _requestPermission();
    Navigator.of(context).pushNamed(
      Routes.taxi,
      arguments: ScreenArguments(
        envType,
        url,
      ),
    );
    // Navigator.of(context).pushReplacementNamed(Routes.taxi);
  }
}

class ScreenArguments {
  final String envType;
  final String url;

  ScreenArguments(this.envType, this.url);
}
