import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:sih/sun/click.dart';

import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:sih/sun/upload.dart';
import 'dart:convert';
import 'package:sih/water/select.dart';
import 'package:geolocator/geolocator.dart';

Map<dynamic, dynamic> temp;
File file;

bool clicked = false;
List<String> image = [];

class SunFirst extends StatefulWidget {
  dynamic latu, longu;
  SunFirst({Key key, @required this.latu, @required this.longu})
      : super(key: key);
  @override
  _SunFirst createState() => _SunFirst();
}

Location location = new Location();
dynamic mod;

class _SunFirst extends State<SunFirst> {
  getApi(String uri, double lats, double lon) async {
    String url = 'http://ec2-18-215-246-9.compute-1.amazonaws.com/sunTurbid';
    var body = {"image": uri, "lat": lats, "longitude": lon};
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print(r.body);
    setState(() {
      mod = json.decode(r.body);
    });
  }

  void getAngle() async {
    // checkLocationpermission();
    String url = "http://ec2-18-215-246-9.compute-1.amazonaws.com/sun";
    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            json.encode(<String, double>{"latitude": lat, "longitude": long}));
    temp = json.decode(response.body);
    setState(() {
      clicked = true;
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => SunClick(
                    temp: temp,
                  )));
    });
  }

  Position _currentPosition;

  // Location
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  double lat, long;

  void checkLocationService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    if (_serviceEnabled) {
      getLocation();
    }
  }

  void checkLocationpermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    if (_permissionGranted == PermissionStatus.granted) {
      checkLocationService();
    }
  }

  void getLocation() async {
    _locationData = await location.getLocation();

    lat = _locationData.latitude;
    long = _locationData.longitude;
  }

//Location

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationpermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "SIH-2020",
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontFamily: "Gilroy"),
        )),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 30),
              GestureDetector(
                onTap: () async {
                  file =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  final bytes2 = File(file.path).readAsBytesSync();
                  String b = base64Encode(bytes2);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          content: Center(child: CircularProgressIndicator()));
                    },
                  );
                  await getApi(b, widget.latu, widget.longu);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Color(0xFF485563),
                        title: Text(
                          "Final Result",
                          style: TextStyle(
                            fontFamily: "Josefin",
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        content: Container(
                            child: Stack(
                          children: <Widget>[
                            Text(
                              mod.toString(),
                              style: TextStyle(
                                fontFamily: "Quicksand",
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                      );
                    },
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4.7,
                  width: MediaQuery.of(context).size.width / 2.7,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff00d2ff), Color(0xff3a7bd5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff3a7bd5).withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 12.0,
                            spreadRadius: 5.0)
                      ]),
                  child: Center(
                      child: Text(
                    "Upload Image",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Gilroy",
                        color: Colors.white),
                  )),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadZeinth()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4.7,
                  width: MediaQuery.of(context).size.width / 2.7,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xff00d2ff), Color(0xff3a7bd5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xff3a7bd5).withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 12.0,
                            spreadRadius: 5.0)
                      ]),
                  child: Center(
                      child: Text(
                    "Upload Images",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Gilroy",
                        color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ],
      ))),
    );
  }
}
