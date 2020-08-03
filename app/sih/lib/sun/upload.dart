import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadZeinth extends StatefulWidget {
  @override
  _UploadZeinth createState() => _UploadZeinth();
}

dynamic temp;

class _UploadZeinth extends State<UploadZeinth> {
  File fill;
  List<String> images = [];
  getApi(double ang1, double ang2, double ang3, double ang4, double ang5,
      String img1, String img2, String img3, String img4, String img5) async {
    String url = 'http://ec2-18-215-246-9.compute-1.amazonaws.com/air';
    var body = {
      "zenith1": ang1,
      "zenith2": ang2,
      "zenith3": ang3,
      "zenith4": ang4,
      "zenith5": ang5,
      "image1": img1,
      "image2": img2,
      "image3": img3,
      "image4": img4,
      "image5": img5
    };
    http.Response r = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    print(r.body);
    setState(() {
      temp = json.decode(r.body);
    });
  }

  bool bot = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(5, (index) {
            return Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: GestureDetector(
                    onTap: () async {
                      if (index == 0) {
                        fill = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                      } else if (index == 1) {
                        fill = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                      } else if (index == 2) {
                        fill = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                      } else if (index == 3) {
                        fill = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                      } else if (index == 4) {
                        fill = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                      }
                      setState(() {
                        bot = true;
                      });
                    },
                    child: fill == null
                        ? Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.pink,
                            ),
                          )
                        : Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: FileImage(fill))),
                          )));
          })),
    );
  }
}
