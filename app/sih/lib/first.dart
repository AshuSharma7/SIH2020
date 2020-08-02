import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sih/sun/click.dart';
import 'package:sih/water/select.dart';
import 'package:geolocator/geolocator.dart';

class SelectTurbid extends StatefulWidget {
  @override
  _SelectTurbid createState() => _SelectTurbid();
}

Location location = new Location();

class _SelectTurbid extends State<SelectTurbid> {
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
      body: Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => SunClick()));
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(5, 5),
                        blurRadius: 5.0,
                        spreadRadius: 1.0)
                  ]),
              child: Center(
                  child: Text(
                "Sun Turbidity",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
            ),
          ),
          SizedBox(height: 30),
          GestureDetector(
            onTap: () async {
              if (lat == null) {
                getLocation();
              }
              if (lat != null && long != null) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => SelectType(
                              lat: lat,
                              long: long,
                            )));
              } else {
                print('bbud');
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width / 1.5,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade400,
                        offset: Offset(5, 5),
                        blurRadius: 5.0,
                        spreadRadius: 1.0)
                  ]),
              child: Center(
                  child: Text(
                "Water Turbidity",
                style: TextStyle(fontSize: 30, color: Colors.white),
              )),
            ),
          ),
        ],
      ))),
    );
  }
}
