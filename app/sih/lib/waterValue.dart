import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

class WaterValue extends StatefulWidget {
  dynamic img;
  WaterValue({Key key, @required this.img}) : super(key: key);
  @override
  _WaterValue createState() => _WaterValue();
}

class _WaterValue extends State<WaterValue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(base64Decode(widget.img)))),
            ),
            SizedBox(height: 10),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: 300,
              child: FlatButton(onPressed: () {}, child: Text("Download")),
            )
          ],
        ),
      ),
    );
  }
}
