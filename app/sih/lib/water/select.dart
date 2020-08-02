import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'package:camera/camera.dart';
import 'package:sensors/sensors.dart';

List<CameraDescription> cameras;
CameraController controller;
AccelerometerEvent event;

class SelectType extends StatefulWidget {
  dynamic lat;
  dynamic long;
  SelectType({Key key, @required this.lat, @required this.long})
      : super(key: key);
  @override
  _SelectType createState() => _SelectType();
}

class _SelectType extends State<SelectType> {
  bool clicked = false;

  Widget cam(String val, Map angles) {
    return Scaffold(body:
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: Stack(
          children: [
            !controller.value.isInitialized
                ? Container()
                : AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // getAngle();
                    },
                    child: Text(
                      false
                          ? "press"
                          : "zenith: " +
                              angles["zenith"].toString() +
                              "\nazimuth: " +
                              angles["azimuth"].toString() +
                              "\nelevation: " +
                              angles["altitude"].toString(),
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        accelerometerEvents.listen((AccelerometerEvent eve) {
                          // print(eve.y * 90 / 10);
                          setState(() {
                            event = eve;
                          });
                        });
                      },
                      child: Text(
                        event == null ? "Press" : "Y: " + getY(),
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 40.0,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        _onCapturePressed(context, val);
                      }),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }));
  }

  Map<dynamic, dynamic> temp;
  void getAngle() async {
    // checkLocationpermission();
    String url = "http://ec2-52-71-253-148.compute-1.amazonaws.com/sun";
    http.Response response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, double>{
          "latitude": widget.lat,
          "longitude": widget.long
        }));
    temp = json.decode(response.body);
    setState(() {
      clicked = true;
    });
  }

  File cameraFile;
  File f1;
  File f2;
  File f3;

  String getY() {
    return ((event.y * 90) / 10).ceilToDouble().toString();
  }

  String getZ() {
    return ((event.z * 90) / 10).ceilToDouble().toString();
  }

  @override
  void initState() {
    cameraGet();
    getAngle();
    super.initState();
  }

  _imageSelect(ImageSource source, String val) async {
    cameraFile = await ImagePicker.pickImage(source: source);
    setState(() {
      if (val == "a") {
        f1 = cameraFile;
      } else if (val == "b") {
        f2 = cameraFile;
      } else if (val == "c") {
        f3 = cameraFile;
      }
    });
  }

  dynamic mod, mod2;

  apiCall(String uri) async {
    String url = 'http://ec2-52-71-253-148.compute-1.amazonaws.com/water';
    var body = {"image": uri};
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

  turbidity(String a, String b, String c) async {
    String url = 'http://ec2-52-71-253-148.compute-1.amazonaws.com/turbidity';
    var body = {"skyImage": a, "waterImage": b, "greyImage": c};
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print(r.body);
    setState(() {
      mod2 = json.decode(r.body);
    });
  }

  void cameraGet() async {
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
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
      body: SingleChildScrollView(
          child: Container(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  f1 == null
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFF485563),
                                      title: Text(
                                        "Select Source",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: "Josefin",
                                        ),
                                      ),
                                      content: Container(
                                          child: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                _imageSelect(
                                                    ImageSource.gallery, "a");
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.add_photo_alternate,
                                                      color: Colors.white70,
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Gallery",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Poiret",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(top: 40),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    cam("a",
                                                                        temp)));
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.camera,
                                                          color: Colors.white70,
                                                          size: 30,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Camera",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Poiret",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )))
                                        ],
                                      )),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xff00d2ff),
                                            Color(0xff3a7bd5)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xff3a7bd5)
                                                .withOpacity(0.3),
                                            offset: Offset(0, 4),
                                            blurRadius: 12.0,
                                            spreadRadius: 5.0)
                                      ]),
                                  child: Center(
                                      child: Text(
                                    "Gray Card",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  )))))
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 2.4,
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                image: DecorationImage(image: FileImage(f1)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    f1 = null;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.delete,
                                    size: 40,
                                  ),
                                ),
                              ))),
                  f2 == null
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Color(0xFF485563),
                                      title: Text(
                                        "Select Source",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontFamily: "Josefin",
                                        ),
                                      ),
                                      content: Container(
                                          child: Stack(
                                        children: <Widget>[
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                _imageSelect(
                                                    ImageSource.gallery, "b");
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.add_photo_alternate,
                                                      color: Colors.white70,
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Gallery",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontFamily: "Poiret",
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(top: 40),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    cam("b",
                                                                        temp)));
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.camera,
                                                          color: Colors.white70,
                                                          size: 30,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          "Camera",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Poiret",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  )))
                                        ],
                                      )),
                                    );
                                  },
                                );
                                // cam("b");
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xff00d2ff),
                                          Color(0xff3a7bd5)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0xff3a7bd5)
                                              .withOpacity(0.3),
                                          offset: Offset(0, 4),
                                          blurRadius: 12.0,
                                          spreadRadius: 5.0)
                                    ]),
                                child: Center(
                                    child: Text(
                                  "Water",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                )),
                              )))
                      : Padding(
                          padding: EdgeInsets.all(10),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width / 2.4,
                              decoration: BoxDecoration(
                                border: Border.all(width: 2),
                                image: DecorationImage(image: FileImage(f2)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    f2 = null;
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.delete,
                                    size: 40,
                                  ),
                                ),
                              ))),
                ],
              ),
              f3 == null
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Color(0xFF485563),
                                  title: Text(
                                    "Select Source",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontFamily: "Josefin",
                                    ),
                                  ),
                                  content: Container(
                                      child: Stack(
                                    children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            _imageSelect(
                                                ImageSource.gallery, "c");
                                          },
                                          child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add_photo_alternate,
                                                  color: Colors.white70,
                                                  size: 30,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Gallery",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: "Poiret",
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(top: 40),
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            cam("c", temp)));
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.camera,
                                                      color: Colors.white70,
                                                      size: 30,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                          fontFamily: "Poiret",
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              )))
                                    ],
                                  )),
                                );
                              },
                            );
                            // cam("c");
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff00d2ff),
                                      Color(0xff3a7bd5)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff3a7bd5).withOpacity(0.3),
                                      offset: Offset(0, 4),
                                      blurRadius: 12.0,
                                      spreadRadius: 5.0)
                                ]),
                            child: Center(
                                child: Text(
                              "Sun",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            )),
                          )))
                  : Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: MediaQuery.of(context).size.width / 2.4,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            image: DecorationImage(image: FileImage(f3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                f3 = null;
                              });
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.delete,
                                size: 40,
                              ),
                            ),
                          ))),
            ],
          ),
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Latitude:  " + widget.lat.toString(),
                style: TextStyle(
                  fontFamily: "Gilroy",
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Longitude:  " + widget.long.toString(),
                style: TextStyle(
                  fontFamily: "Gilroy",
                  fontSize: 30,
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          f1 != null && f2 != null && f3 != null
              ? Container(
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: FlatButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                content:
                                    Center(child: CircularProgressIndicator()));
                          },
                        );
                        final bytes = File(f1.path).readAsBytesSync();
                        String a = base64Encode(bytes);

                        final bytes2 = File(f2.path).readAsBytesSync();
                        String b = base64Encode(bytes2);

                        final bytes3 = File(f3.path).readAsBytesSync();
                        String c = base64Encode(bytes3);

                        await apiCall(b);
                        await turbidity(a, b, c);

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
                                    mod["message"].toString(),
                                    style: TextStyle(
                                      fontFamily: "Quicksand",
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Text(
                                        "Turbidity Value:  " +
                                            mod2["turbidity"].toString(),
                                        style: TextStyle(
                                          fontFamily: "Quicksand",
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ))
                                ],
                              )),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 20),
                      )))
              : Container(
                  child: Text(
                  "Please Select All 3 Images",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Quicksand"),
                ))
        ],
      ))),
    );
  }

  void _onCapturePressed(context, String s) async {
    try {
      // 1
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      // 2
      await controller.takePicture(path);
      setState(() {
        if (s == "a") {
          f1 = File(path);
          Navigator.pop(context);
        } else if (s == "b") {
          f2 = File(path);
          Navigator.pop(context);
        } else if (s == "c") {
          f3 = File(path);
          Navigator.pop(context);
        }
      });
      // 3
    } catch (e) {
      print(e);
    }
  }
}
