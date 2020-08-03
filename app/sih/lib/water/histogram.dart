import 'dart:convert';

import 'package:flutter/material.dart';

class HistogramWater extends StatefulWidget {
  String water;
  String gray;
  String sky;
  HistogramWater(
      {Key key, @required this.gray, @required this.water, @required this.sky})
      : super(key: key);
  @override
  _HistogramWater createState() => _HistogramWater();
}

class _HistogramWater extends State<HistogramWater> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  Text(
                    "Water HistoGram",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontFamily: "Poiret"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(base64Decode(widget.water)))),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "Sun HistoGram",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontFamily: "Poiret"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(base64Decode(widget.sky)))),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Text(
                    "GrayCard Histogram",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontFamily: "Poiret"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(base64Decode(widget.gray)))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
