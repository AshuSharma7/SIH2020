import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  dynamic mod;
  Upload({Key key, @required this.mod}) : super(key: key);
  @override
  _Upload createState() => _Upload();
}

class _Upload extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            
          )
        ],
      )),
    );
  }
}
