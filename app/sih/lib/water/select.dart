import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';

class SelectType extends StatefulWidget {
  dynamic lat;
  dynamic long;
  SelectType({Key key, @required this.lat, @required this.long})
      : super(key: key);
  @override
  _SelectType createState() => _SelectType();
}

class _SelectType extends State<SelectType> {
  File cameraFile;
  File f1;
  File f2;
  File f3;

  _imageSelect(String val) async {
    cameraFile = await ImagePicker.pickImage(source: ImageSource.camera);
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

  Future uploadPic(BuildContext context, File _image) async {
    String fileName = _image.path;
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final String url = await firebaseStorageRef.getDownloadURL();

    print(url);
    setState(() {
      apiCall(url);
    });
  }

  dynamic mod;
  apiCall(String uri) async {
    String url = 'http://ec2-52-71-253-148.compute-1.amazonaws.com/water';
    var body = {"imageurl": uri};
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    setState(() {
      mod = json.decode(r.body);
    });
    print(mod["message"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 40),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  f1 == null
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                              onTap: () {
                                _imageSelect("a");
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: Offset(5, 5),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0)
                                    ]),
                                child: Center(
                                    child: Text(
                                  "Gray Card",
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
                                image: DecorationImage(image: FileImage(f1)),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: Offset(5, 5),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0)
                                ]),
                          )),
                  f2 == null
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                              onTap: () {
                                _imageSelect("b");
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 4,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade400,
                                          offset: Offset(5, 5),
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0)
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
                                image: DecorationImage(image: FileImage(f2)),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: Offset(5, 5),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0)
                                ]),
                          )),
                ],
              ),
              f3 == null
                  ? Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                          onTap: () {
                            _imageSelect("c");
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade400,
                                      offset: Offset(5, 5),
                                      blurRadius: 5.0,
                                      spreadRadius: 1.0)
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
                            image: DecorationImage(image: FileImage(f3)),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  offset: Offset(5, 5),
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0)
                            ]),
                      )),
            ],
          ),
          SizedBox(height: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Latitude:  " + widget.lat.toString(),
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Longitude:  " + widget.long.toString(),
                style: TextStyle(
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
                        await uploadPic(context, f2);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            Widget continueButton = FlatButton(
                              child: Text("Ok"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            );
                            return AlertDialog(
                              title: Text("Turbidity Value"),
                              content: Text(mod["message"].toString()),
                              actions: [
                                continueButton,
                              ],
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
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ))
        ],
      )),
    );
  }
}
