import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

class GyroCamera extends StatefulWidget {
  dynamic lat;
  dynamic long;
  GyroCamera({Key key, @required this.lat, @required this.long})
      : super(key: key);
  @override
  _GyroCamera createState() => _GyroCamera();
}

class _GyroCamera extends State<GyroCamera> {
  AccelerometerEvent event;
  CameraController controller;
  Map<dynamic, dynamic> temp;

  File img;
  bool clicked = false;

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

  String getY() {
    return ((event.y * 90) / 10).ceilToDouble().toString();
  }

  String getZ() {
    return ((event.z * 90) / 10).ceilToDouble().toString();
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
  void initState() {
    cameraGet();
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      getAngle();
                    },
                    child: Text(
                      !clicked
                          ? "press"
                          : "zenith: " +
                              temp["zenith"].toString() +
                              "\nazimuth: " +
                              temp["azimuth"].toString() +
                              "\nelevation: " +
                              temp["altitude"].toString(),
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
                        try {
                          final path = join(
                            (await getTemporaryDirectory()).path,
                            '${DateTime.now()}.png',
                          );
                          await controller.takePicture(path);
                          setState(() {
                            img = File(path);
                            
                          });
                        } catch (e) {
                          print(e);
                        }
                      }),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
