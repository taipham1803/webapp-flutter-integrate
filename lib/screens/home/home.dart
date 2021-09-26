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
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        // appBar: EmptyAppBar(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('myLocal App'),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          // set the width of this Container to 100% screen width
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            // Vertically center the widget inside the column
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonNavigate('Development version', 'https://asim.emddi.xyz',
                  Colors.orange, () {
                _navigateToTaxiFeature('dev', 'https://asim.emddi.xyz');
                return;
              }),
              ButtonNavigate('Development version',
                  'https://mylocalxenginx01.mylocal.vn', Colors.orange, () {
                _navigateToTaxiFeature(
                    'dev', 'https://mylocalxenginx01.mylocal.vn');
                return;
              }),
              ButtonNavigate(
                  'Production version',
                  'https://apim.mylocal.vn/apipayment/mylocal/1.0',
                  Colors.blueAccent, () {
                _navigateToTaxiFeature(
                    'prod', 'https://apim.mylocal.vn/apipayment/mylocal/1.0');
                return;
              }),
              InputUrlButton(context),
            ],
          ),
        ));
  }

  Widget ButtonNavigate(
      String title, String subTitle, Color color, Function onPress) {
    return Container(
      margin: new EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        color: color,
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              subTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        onPressed: onPress,
      ),
    );
  }

  Widget InputUrlButton(BuildContext context) {

    return Container(
      margin: new EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your custom webview url',
              ),
            ),
          ),
          FlatButton(
            color: Colors.blue,
            onPressed: () {
              bool _validWebviewURL = Uri.parse(myController.text).isAbsolute;
              if(!_validWebviewURL){
                _showDialog("Invalid Url", "Your input text is not a valid web uri!");
                return;
              }
              _navigateToTaxiFeature('manual', myController.text);
            },
            child: Text(
              'OK',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
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

  void _showDialog(String title, String body) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(body),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ScreenArguments {
  final String envType;
  final String url;
  ScreenArguments(this.envType, this.url);
}

