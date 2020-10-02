import 'package:flutter/cupertino.dart';
import 'package:hudat/measure-size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'picture.dart';
import 'dart:convert';
import 'dart:io';

class DisplayPictureScreen extends StatefulWidget {
  final Picture picture;

  const DisplayPictureScreen({Key key, this.picture}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DisplayPictureScreenState();
}

class DisplayPictureScreenState extends State<DisplayPictureScreen> {

  Size size = Size.zero;

  @override
  Widget build(BuildContext context) {
    var celebrityData = jsonDecode(widget.picture.celebrityData);

    var celebrities =
    List<dynamic>.from(celebrityData['CelebrityFaces']).map((c) {
      var boundingBox = c['Face']['BoundingBox'];
      return Positioned(
        top:
        boundingBox['Top'] * size.height,
        left: boundingBox['Left'] * size.width,
        child: InkWell(
          onTap: () {
            launch('https://' + c['Urls'][0]);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.2),
              border: Border.all(width: 2.0, color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
            width: boundingBox['Width'] * size.width,
            height: boundingBox['Height'] * size.height,
            child: Center(
              child: Text(c['Name'], textAlign: TextAlign.center)),
            padding: EdgeInsets.all(4.0))));
    });


    var stackChildren = <Widget>[
      MeasureSize(
        onChange: (size) {
          print(size);
          setState(() => this.size = size);
        },
        child: Image.file(File(widget.picture.filepath)))
    ];
    celebrities.forEach((element) {
      stackChildren.add(element);
    });

    return Scaffold(
      appBar: AppBar(title: Text('Picture Details')),
      body: Container(child: Stack(children: stackChildren)));
  }

}
