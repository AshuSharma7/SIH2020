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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => SunClick()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 4.7,
                  width: MediaQuery.of(context).size.width / 2.7,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffff9966), Color(0xffff5e62)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xffff5e62).withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 15.0,
                            spreadRadius: 5.0)
                      ]),
                  child: Center(
                      child:
                          //      Image.asset(
                          //   "assets/sun(1).png",
                          //   width: 70.0,
                          // )
                          Text(
                    "Sun Turbidity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "Gilroy"),
                  )),
                ),
              ),
              SizedBox(width: 30),
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
                      child:
                          //     Image.asset(
                          //   "assets/rain-drops.png",
                          //   width: 70.0,
                          // )
                          Text(
                    "Water Turbidity",
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
          SizedBox(
            height: 70.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 60,
            height: 60.0,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffFF5F6D), Color(0xffFFC371)],
                    end: Alignment.bottomLeft,
                    begin: Alignment.topRight),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffFF5F6D).withOpacity(0.3),
                      offset: Offset(0, 3),
                      blurRadius: 10.0,
                      spreadRadius: 3.0)
                ]),
            child: Center(
              child: Text(
                "About app",
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Gilroy",
                    color: Colors.white70),
              ),
            ),
          )
        ],
      ))),
    );
  }
}
